//
//  DrawingLotData.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import Foundation

class DrawingLotData: ObservableObject {
    @Published var numberSets: [Group: [Int]] = [:]
    
    init() {
        reset()
    }
    
    func add(_ numberSet: [Int], forGroup group: Group) -> Bool {
        guard numberSet.count == 6 else { return false }
        
        numberSets[group] = numberSet
        return true
    }
    
    func update(_ group: Group, to numberSet: [Int]) {
        numberSets[group] = numberSet
    }
    
    func update(_ group: Group, to number: [Int], at index: Int) {
    }
    
    func delete(_ group: Group) {
        numberSets[group] = nil
    }
    
    func reset() {
        for group in Group.allCases {
            self.numberSets[group] = Array.init(repeating: 0, count: 6)
        }
    }
    
    func drawLot() {
        for group in Group.allCases {
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
}

enum Group: String, CaseIterable, Identifiable, Comparable {
    case a = "A"
    case b = "B"
    case c = "C"
    case d = "D"
    case e = "E"
    
    var id: String { self.rawValue }
    static func < (lhs: Group, rhs: Group) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
