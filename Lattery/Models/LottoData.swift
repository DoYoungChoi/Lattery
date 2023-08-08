//
//  LottoData.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import Foundation
import CoreData

class LottoData: ObservableObject {
    // reset number는 0
    @Published var numberGroups = [LottoGroup: [Int16]]()
    @Published var selectedGroup: LottoGroup? = nil
    @Published var selectedNumbers = [LottoGroup: Set<Int16>]()
    @Published var favorites = [Set<Int16>]()
    @Published var isEnded: Bool = false
    @Published var numberCombination = Set<Int16>()
    
    // MARK: - 초기함수, 리셋
    init() {
        totallyReset()
        getFavorites()
    }
    
    func totallyReset() {
        for group in LottoGroup.allCases {
            self.numberGroups[group] = Array(repeating: 0, count: 6)
            selectedGroup = nil
            selectedNumbers = [LottoGroup: Set<Int16>]()
        }
        numberCombination = Set<Int16>()
    }
    
    func reset() {
        for group in LottoGroup.allCases {
            if let selected = selectedNumbers[group] {
                self.numberGroups[group] = Array(selected).sorted() + Array(repeating: 0, count: 6 - selected.count)
            } else {
                self.numberGroups[group] = Array(repeating: 0, count: 6)
            }
        }
    }
    
    // MARK: - 번호 추첨
    func drawLot() {
        for group in LottoGroup.allCases {
            var numbers: [Int16] = Array(selectedNumbers[group] ?? [])
            while numbers.count < 6 {
                let number = Int16.random(in: 1...45)
                if !numbers.contains(number) {
                    numbers.append(number)
                }
            }
            self.numberGroups[group] = numbers.sorted()
        }
    }
    
    // MARK: - 추첨 고정 번호
    func addSelectedNumbers(_ numbers: Set<Int16>) {
        guard let group = selectedGroup else { return }
        selectedNumbers[group] = numbers
        self.numberGroups[group] = Array(selectedNumbers[group]!).sorted() + Array(repeating: 0, count: 6-selectedNumbers[group]!.count)
    }
    
    func deleteSelectedNumber(_ number: Int16) {
        guard let group = selectedGroup else { return }
        selectedNumbers[group]?.remove(number)
    }
    
    // MARK: - 즐겨찾기 숫자 조합
    func addFavorites(_ numbers: Set<Int16>) {
        if !favorites.contains(numbers) {
            favorites.append(numbers)
            setFavorites()
        }
    }
    
    func deleteFavorites(_ numbers: Set<Int16>) {
        if let index = favorites.firstIndex(of: numbers) {
            favorites.remove(at: index)
            setFavorites()
        }
    }
    
    // For UserDefaults (type from [String] to [Set<Int16>]
    // ["1,2,3", "3,4,5"]
    private func getFavorites() {
        var favorites: [Set<Int16>] = []
        let favoritesFromUD = UserDefaults.standard.stringArray(forKey: favoritesLottoKey) ?? []
        for favoriteFromUD in favoritesFromUD {
            var favorite: [Int16] = []
            let numbers = favoriteFromUD.split(separator: ",")
            for number in numbers {
                favorite.append(Int16(number) ?? 0)
            }
            favorites.append(Set(favorite))
        }
        self.favorites = favorites
    }
    
    // For UserDefaults (type from [Set<Int16>] to [String]
    private func setFavorites() {
        var favoritesToUD: [String] = []
        for favorite in self.favorites {
            let numbers = favorite.map { String($0) }.joined(separator: ",")
            print(numbers)
            favoritesToUD.append(numbers)
        }
        UserDefaults.standard.set(favoritesToUD, forKey: favoritesLottoKey)
    }
    
    // MARK: - 로또 최신 정보
    private func getLastest() -> Lastest? {
        if let savedData = UserDefaults.standard.object(forKey: lastestLottoKey) as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode(Lastest.self, from: savedData) {
                return savedObject
            } else {
                return nil
            }
        } else {
            return Lastest(id: lastestLottoKey, round: 0)
        }
    }
    
    private func setLastest(round: Int, date: Date) -> Bool {
        let lastest = Lastest(id: lastestLottoKey, round: round, date: date)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(lastest) {
            UserDefaults.standard.setValue(encoded, forKey: lastestLottoKey)
        } else {
            return false
        }
        return true
    }
    
    // MARK: - 로또 번호 가져오기
    func fetchData(_ round: Int) async throws -> Lotto {
        guard let url = URL(string: "https://dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(round)") else { throw FetchError.badURL }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode else { throw FetchError.badRequest }
        
        guard let lotto: Lotto = try? JSONDecoder().decode(Lotto.self, from: data) else { throw FetchError.badJSON }
        guard lotto.returnValue == "success" else { throw FetchError.badResponse }
        
        return lotto
    }
    
    private func save(lotto: Lotto, context: NSManagedObjectContext) -> Date? {
        guard let round = lotto.drwNo else { return nil }
        
        let lottoE = LottoEntity(context: context)
        lottoE.round = Int16(lotto.drwNo ?? round)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        // 매주 토요일 20:35 발표
        lottoE.date = formatter.date(from: lotto.drwNoDate ?? "")?.addingTimeInterval(60 * 60 * 20 + 60 * 35)
        lottoE.winnerCount = Int16(lotto.firstPrzwnerCo ?? 0)
        lottoE.winnerReward = lotto.firstWinamnt ?? 0
        lottoE.totalSalesAmount = lotto.totSellamnt ?? 0
        lottoE.no1 = Int16(lotto.drwtNo1 ?? 0)
        lottoE.no2 = Int16(lotto.drwtNo2 ?? 0)
        lottoE.no3 = Int16(lotto.drwtNo3 ?? 0)
        lottoE.no4 = Int16(lotto.drwtNo4 ?? 0)
        lottoE.no5 = Int16(lotto.drwtNo5 ?? 0)
        lottoE.no6 = Int16(lotto.drwtNo6 ?? 0)
        lottoE.noBonus = Int16(lotto.bnusNo ?? 0)
        return lottoE.date
    }
    
    func getLastestData(context: NSManagedObjectContext) async -> String? {
        guard let lastest = getLastest() else { return LastestError.userDefaultsError.rawValue }
        print("lotto lastes: \(lastest)")
        var success = true
        var resultMessage: String? = nil
        var round: Int = lastest.round
        var date: Date?
        while (success) {
            round += 1
            do {
                let lotto = try await fetchData(round)
                date = save(lotto: lotto, context: context)
            } catch FetchError.badURL {
                success = false
                resultMessage = LastestError.requestError.rawValue
            } catch FetchError.badRequest {
                success = false
                resultMessage = LastestError.requestError.rawValue
            } catch FetchError.badJSON {
                success = false
                resultMessage = LastestError.serverError.rawValue
            } catch FetchError.badResponse {
                success = false
                resultMessage = nil // 최신 데이터라 가정
            } catch {
                success = false
                resultMessage = LastestError.unknownError.rawValue
            }
        }
        
        if lastest.round < round - 1 {
            // CoreData에 데이터 저장
            PersistenceController.shared.save()
            // Lastest에 셋팅
            let _ = setLastest(round: round - 1, date: date!)
        }
        
        return resultMessage
    }
}

enum LottoGroup: String, CaseIterable, Identifiable, Comparable {
    case a = "A"
    case b = "B"
    case c = "C"
    case d = "D"
    case e = "E"
    
    var id: String { self.rawValue }
    static func < (lhs: LottoGroup, rhs: LottoGroup) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

