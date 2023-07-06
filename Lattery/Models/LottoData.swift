//
//  LottoData.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import Foundation

class LottoData: ObservableObject {
    @Published var numberSets: [LottoGroup: [Int]] = [:]
    
    init() {
        reset()
    }
    
    func add(_ numberSet: [Int], forGroup group: LottoGroup) -> Bool {
        guard numberSet.count == 6 else { return false }
        
        numberSets[group] = numberSet
        return true
    }
    
    func update(_ group: LottoGroup, to numberSet: [Int]) {
        numberSets[group] = numberSet
    }
    
    func update(_ group: LottoGroup, to number: [Int], at index: Int) {
    }
    
    func delete(_ group: LottoGroup) {
        numberSets[group] = nil
    }
    
    func reset() {
        for group in LottoGroup.allCases {
            self.numberSets[group] = Array.init(repeating: 0, count: 6)
        }
    }
    
    func drawLot() {
        for group in LottoGroup.allCases {
            var numberSet: [Int] = []
            while numberSet.count < 6 {
                let number = Int.random(in: 1...45)
                if !numberSet.contains(number) {
                    numberSet.append(number)
                }
            }
            self.numberSets[group] = numberSet.sorted()
        }
    }
    
    enum FetchError: Error {
        case badURL
        case badRequest
        case badResponse
        case badJSON
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
