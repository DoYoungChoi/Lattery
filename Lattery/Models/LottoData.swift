//
//  LottoData.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import Foundation

class LottoData: ObservableObject {
    @Published var numberGroups = [LottoGroup: [Int16]]()
    @Published var selectedGroup: LottoGroup? = nil
    @Published var selectedNumbers = [LottoGroup: Set<Int16>]()
    @Published var favorites = [Set<Int16>]()
    
    init() {
        totallyReset()
    }
    
    func addSelectedNumbers(_ numbers: Set<Int16>) {
        guard let group = selectedGroup else { return }
        selectedNumbers[group] = numbers
        self.numberGroups[group] = Array(selectedNumbers[group]!).sorted() + Array(repeating: 0, count: 6-selectedNumbers[group]!.count)
    }
    
    func deleteFixedNumber(_ number: Int16) {
        guard let group = selectedGroup else { return }
        selectedNumbers[group]?.remove(number)
    }
    
    func addFavorites(_ numbers: Set<Int16>) {
        if !favorites.contains(numbers) {
            favorites.append(numbers)
        }
    }
    
    func deleteFavorites(_ numbers: Set<Int16>) {
        if let index = favorites.firstIndex(of: numbers) {
            favorites.remove(at: index)
        }
    }
    
    func totallyReset() {
        for group in LottoGroup.allCases {
            self.numberGroups[group] = Array(repeating: 0, count: 6)
            selectedGroup = nil
            selectedNumbers = [LottoGroup: Set<Int16>]()
        }
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
    
    func fetchData(_ nth: Int) async throws -> Lotto {
        guard let url = URL(string: "https://dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(nth)") else { throw FetchError.badURL }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode else { throw FetchError.badRequest }
        
        guard let lotto: Lotto = try? JSONDecoder().decode(Lotto.self, from: data) else { throw FetchError.badJSON }
        guard lotto.returnValue == "success" else { throw FetchError.badResponse }
        
        return lotto
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

enum FetchError: Error {
    case badURL
    case badRequest
    case badResponse
    case badJSON
}
