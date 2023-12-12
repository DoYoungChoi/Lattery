//
//  Lotto.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import Foundation

struct LottoNumbers: Hashable {
    var numbers: [Int]
    var bonus: Int? = nil
    var fixedNumbers: [Int] = []
    
    init(
        numbers: [Int],
        bonus: Int? = nil,
        fixedNumbers: [Int] = []
    ) {
        self.numbers = numbers
        self.bonus = bonus
        self.fixedNumbers = fixedNumbers
    }
    
    init(
        fixedNumbers: [Int]
    ) {
        self.numbers = fixedNumbers
        self.bonus = nil
        self.fixedNumbers = fixedNumbers
    }
}
