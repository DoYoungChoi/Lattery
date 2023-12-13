//
//  PensionNumbers.swift
//  Lattery
//
//  Created by dodor on 12/12/23.
//

import Foundation

struct PensionNumbers: Hashable {
    var numbers: [Int?]
    var fixedNumbers: [Int?] = []
    
    init(numbers: [Int?],
         fixedNumbers: [Int?] = []) {
        self.numbers = numbers
        self.fixedNumbers = fixedNumbers
    }
    
    init(fixedNumbers: [Int?]) {
        self.numbers = fixedNumbers
        self.fixedNumbers = fixedNumbers
    }
}
