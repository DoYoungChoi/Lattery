//
//  PensionData.swift
//  Lattery
//
//  Created by dodor on 2023/07/15.
//

import Foundation
import CoreData

class PensionData: ObservableObject {
    @Published var pensionGroup: PensionGroup = .allGroup
    // reset number는 -1
    // 모든 조에 대한 경우는 숫자 조합만 6개 Elements를 가진 Array
    // 조까지 추첨받는 경우는 조 + 숫자 조합까지 7개 Elements를 가진 Array
    @Published var numberGroupForAll: [Int16] = Array(repeating: -1, count: 6)
    @Published var selectedNumbersForAll = [Int16]()
    @Published var groupCount: Int = 1
    @Published var numberGroupsForEach: [[Int16]] = [Array(repeating: -1, count: 7)]
    @Published var selectedGroup: Int = 1
    @Published var selectedNumbersForEach = [[Int16]]()
    @Published var isEnded: Bool = false
    @Published var numberCombination = [Int16]()
    @Published var savedPension: PensionResult? = nil
    var isSaved: Bool {
        savedPension != nil
    }
    
    // MARK: - 초기함수, 리셋
    init() {
        totallyReset()
    }
    
    func totallyReset() {
        numberGroupForAll = Array(repeating: -1, count: 6)
        selectedNumbersForAll = []
        groupCount = 1
        numberGroupsForEach = [Array(repeating: -1, count: 7)]
        selectedGroup = 1
        selectedNumbersForEach = []
        numberCombination = Array(repeating: -1, count: 7)
        savedPension = nil
    }
    
    func reset() {
        resetForAll()
        resetForEach()
    }
    
    private func resetForAll() {
        if selectedNumbersForAll.count < 1 {
            numberGroupForAll = Array(repeating: -1, count: 6)
        } else {
            numberGroupForAll = selectedNumbersForAll
        }
        savedPension = nil
    }
    
    private func resetForEach() {
        var newNumbers = [[Int16]]()
        for index in 0..<groupCount {
            if index < selectedNumbersForEach.count {
                newNumbers.append(selectedNumbersForEach[index])
            } else {
                newNumbers.append(Array(repeating: -1, count: 7))
            }
        }
        numberGroupsForEach = newNumbers
        savedPension = nil
    }
    
    // MARK: - 번호 추첨
    func drawLot() {
        savedPension = nil
        if pensionGroup == .allGroup {
            drawLotForAll()
        } else {
            drawLotForEach()
        }
    }
    
    private func drawLotForAll() {
        var numbers: [Int16] = []
        for i in 0..<6 {
            if i < selectedNumbersForAll.count && selectedNumbersForAll[i] != -1 {
                numbers.append(selectedNumbersForAll[i])
            } else {
                numbers.append(Int16.random(in: 0...9))
            }
        }
        numberGroupForAll = numbers
    }
    
    private func drawLotForEach() {
        var numbers: [[Int16]] = []
        for i in 0..<groupCount {
            var group: [Int16] = []
            if i < selectedNumbersForEach.count {
                for selectedNumber in selectedNumbersForEach[i] {
                    if selectedNumber != -1 {
                        group.append(selectedNumber)
                    } else {
                        if group.count < 1 {
                            group.append(Int16.random(in: 1...5))
                        } else {
                            group.append(Int16.random(in: 0...9))
                        }
                    }
                }
            } else {
                for _ in 0..<7 {
                    if group.count < 1 {
                        group.append(Int16.random(in: 1...5))
                    } else {
                        group.append(Int16.random(in: 0...9))
                    }
                }
            }
            numbers.append(group)
        }
        numberGroupsForEach = numbers
    }
    
    // MARK: - 추첨 고정 번호
    func changePensionGroup(to pensionGroup: PensionGroup) {
        self.pensionGroup = pensionGroup
        reset()
    }
    
    func addSelectedNumberGroup() {
        groupCount += 1
        reset()
    }
    
    func removeSelectedNumberGroup() {
        groupCount -= 1
        if selectedNumbersForEach.count > groupCount {
            selectedNumbersForEach = Array(selectedNumbersForEach[0..<groupCount])
        }
        reset()
    }
    
    func addSelectedNumbers(_ numbers: [[Int16]]) {
        if pensionGroup == .allGroup {
            var replaceNumbers = [Int16]()
            if numbers[0].filter({ $0 != -1 }).count > 0 {
                replaceNumbers = Array(numbers[0].suffix(from: 1))
            }
            selectedNumbersForAll = replaceNumbers
        } else {
            var replaceNumbers = [[Int16]]()
            for nums in numbers {
                if nums.filter({ $0 != -1 }).count > 0 {
                    replaceNumbers.append(nums)
                }
            }
            selectedNumbersForEach = replaceNumbers
        }
        
        reset()
    }
    
//    func deleteSelectedNumber() {
//        
//    }
    
    // MARK: - 연금 복권 최신 정보
    private func getLastest() -> Lastest? {
        if let savedData = UserDefaults.standard.object(forKey: lastestPensionKey) as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode(Lastest.self, from: savedData) {
                return savedObject
            } else {
                return nil
            }
        } else {
            return Lastest(id: lastestPensionKey, round: 0)
        }
    }
    
    private func setLastest(round: Int, date: Date) -> Bool {
        let lastest = Lastest(id: lastestPensionKey, round: round, date: date)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(lastest) {
            UserDefaults.standard.setValue(encoded, forKey: lastestPensionKey)
        } else {
            return false
        }
        return true
    }
    
    // MARK: - 연금복권 번호 가져오기
    func fetchData(_ round: Int) async throws -> Pension {
        guard let url = URL(string: "https://dhlottery.co.kr/common.do?method=get720Number&drwNo=\(round)") else { throw FetchError.badURL }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode else { throw FetchError.badRequest }
        //        print("\(url) Returned: \(String(data: data, encoding: .utf8) ?? "--")")
        
        guard let pension: Pension = try? JSONDecoder().decode(Pension.self, from: data) else { throw FetchError.badJSON }
        guard pension.rows2.filter({ $0.rank == "1" }).count > 0 else { throw FetchError.badResponse }
        
        return pension
    }
    
    private func save(pension: Pension, context: NSManagedObjectContext) -> Date? {
        guard let winData = pension.rows2.filter({ $0.rank == "1" }).first else { return nil }
        guard let round = Int16(winData.round) else { return nil }
        let bonusData = pension.rows1.first
        
        let pensionE = PensionEntity(context: context)
        pensionE.round = round
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        // 매주 목요일 19:05 발표
        pensionE.date = formatter.date(from: winData.pensionDrawDate)?.addingTimeInterval(60 * 60 * 19 + 60 * 5)
        pensionE.winClass = Int16(winData.rankClass) ?? 0
        pensionE.winNumbers = winData.rankNo
        pensionE.bonusNumbers = bonusData?.rankNo
        return pensionE.date
    }
    
    func getLastestData(context: NSManagedObjectContext) async -> String? {
        guard let lastest = getLastest() else { return LastestError.userDefaultsError.rawValue }
        var success = true
        var resultMessage: String? = nil
        var round: Int = lastest.round
        var date: Date?
        while (success) {
            round += 1
            do {
                let pension = try await fetchData(round)
                date = save(pension: pension, context: context)
                if date == nil {
                    success = false
                    resultMessage = LastestError.coreDataError.rawValue
                }
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
            _ = setLastest(round: round - 1, date: date ?? Date.now)
        }
        
        return resultMessage
    }
    
    func fetchAllData(context: NSManagedObjectContext) async -> String? {
        // 기존의 저장된 CoreData를 모두 지운다
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PensionEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? context.execute(batchDeleteRequest)
        
        // 1회부터 fetch 시작
        var round: Int = 1
        var success = true
        var date: Date?
        var resultMessage: String? = nil
        while (success) {
            round += 1
            do {
                let pension = try await fetchData(round)
                date = save(pension: pension, context: context)
                if date == nil {
                    success = false
                    resultMessage = LastestError.coreDataError.rawValue
                }
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
        
        // CoreData에 데이터 저장
        PersistenceController.shared.save()
        // Lastest에 셋팅
        _ = setLastest(round: round - 1, date: date ?? Date.now)
        
        return resultMessage
    }
    
    func savePensionResult(_ context: NSManagedObjectContext) {
        let result = PensionResult(context: context)
        result.date = Date.now
        result.lotteryDate = result.date?.nextThursday.toDateStringSlash
        if pensionGroup == .allGroup {
            result.numbers1 = "1\(numberGroupForAll.map { String($0) }.joined(separator: ""))"
            result.numbers2 = "2\(numberGroupForAll.map { String($0) }.joined(separator: ""))"
            result.numbers3 = "3\(numberGroupForAll.map { String($0) }.joined(separator: ""))"
            result.numbers4 = "4\(numberGroupForAll.map { String($0) }.joined(separator: ""))"
            result.numbers5 = "5\(numberGroupForAll.map { String($0) }.joined(separator: ""))"
        } else {
            let count = numberGroupsForEach.count
            if count > 0 { result.numbers1 = numberGroupsForEach[0].map { String($0) }.joined(separator: "") }
            if count > 1 { result.numbers2 = numberGroupsForEach[1].map { String($0) }.joined(separator: "") }
            if count > 2 { result.numbers3 = numberGroupsForEach[2].map { String($0) }.joined(separator: "") }
            if count > 3 { result.numbers4 = numberGroupsForEach[3].map { String($0) }.joined(separator: "") }
            if count > 4 { result.numbers5 = numberGroupsForEach[4].map { String($0) }.joined(separator: "") }
        }
        
        savedPension = result
        PersistenceController.shared.save()
    }
    
    func deletePensionResult(_ pension: PensionResult?, context: NSManagedObjectContext) {
        if let pension = pension {
            context.delete(pension)
        } else {
            if let savedPension = savedPension {
                context.delete(savedPension)
            }
            savedPension = nil
        }
        PersistenceController.shared.save()
    }
}

enum PensionGroup: String, Identifiable, CaseIterable {
    case allGroup = "모든조"
    case eachGroup = "조추첨"
    
    var id: String { self.rawValue }
}
