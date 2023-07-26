//
//  PensionData.swift
//  Lattery
//
//  Created by dodor on 2023/07/15.
//

import Foundation

class PensionData: ObservableObject {
    @Published var fixedNumbers = [[Int16]]()
    @Published var pensionGroup: PensionGroup = .allGroup
    @Published var sets = [[Int16]]()
    
    init() {
        reset()
    }
    
    func reset() {
        sets = [[Int16]]()
        if pensionGroup == .allGroup {
            for group in 1...5 {
                let numbers = [Int16(group)] + Array(repeating: -1, count: 6)
                sets.append(numbers)
            }
        } else if pensionGroup == .eachGroup {
            var setCount = sets.count
            if setCount == 0 {
                setCount = 1
            }
            for _ in 1...setCount {
                let numbers = Array(repeating: Int16(-1), count: 7)
                sets.append(numbers)
            }
        }
    }
    
    func drawLot() {
    }
    
    func fetchData(_ nth: Int) async throws -> Pension {
        guard let url = URL(string: "https://dhlottery.co.kr/common.do?method=get720Number&drwNo=\(nth)") else { throw FetchError.badURL }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode else { throw FetchError.badRequest }
//        print("\(url) Returned: \(String(data: data, encoding: .utf8) ?? "--")")
        
        guard let pension: Pension = try? JSONDecoder().decode(Pension.self, from: data) else { throw FetchError.badJSON }
        
        return pension
    }
}

enum PensionGroup: String, Identifiable, CaseIterable {
    case allGroup = "모든조"
    case eachGroup = "조선택"
    
    var id: String { self.rawValue }
}
