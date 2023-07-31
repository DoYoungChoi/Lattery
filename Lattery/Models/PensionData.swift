//
//  PensionData.swift
//  Lattery
//
//  Created by dodor on 2023/07/15.
//

import Foundation

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
    }
    
    func drawLot() {
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
