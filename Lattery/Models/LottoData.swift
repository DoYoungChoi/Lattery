//
//  LottoData.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import Foundation

class LottoData: ObservableObject {
    @Published var fixedNumbers = [LottoGroup: Set<Int16>]()
    @Published var numbers = [LottoGroup: [Int16]]()
    @Published var selectedGroup: LottoGroup? = nil
    
    init() {
        reset()
    }
    
    func setFixedNumbers(_ numbers: [Int16]) -> Bool {
        guard let group = selectedGroup else { return false }
        fixedNumbers[group] = Set(numbers)
        self.numbers[group] = Array(fixedNumbers[group]!).sorted() + Array(repeating: 0, count: 6-fixedNumbers[group]!.count)
        return true
    }
    
    func deleteFixedNumber(_ number: Int16) -> Bool {
        guard let group = selectedGroup else { return false }
        return (fixedNumbers[group]?.remove(number) != nil) ? true : false
    }
    
    func reset() {
        for group in LottoGroup.allCases {
            if let fixed = fixedNumbers[group] {
                self.numbers[group] = Array(fixed).sorted() + Array(repeating: 0, count: 6 - fixed.count)
            } else {
                self.numbers[group] = Array(repeating: 0, count: 6)
            }
        }
    }
    
    func drawLot() {
        for group in LottoGroup.allCases {
            var numbers: [Int16] = Array(fixedNumbers[group] ?? [])
            while numbers.count < 6 {
                let number = Int16.random(in: 1...45)
                if !numbers.contains(number) {
                    numbers.append(number)
                }
            }
            self.numbers[group] = numbers.sorted()
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
