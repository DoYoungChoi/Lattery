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
}
