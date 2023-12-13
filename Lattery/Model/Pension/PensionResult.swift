//
//  PensionResult.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import Foundation

struct PensionResult: Identifiable {
    var id: Int { round }
    var round: Int
    var date: Date
    var numbers: PensionNumbers
    var bonus: PensionNumbers
}

extension PensionResult {
    static let stub1: PensionResult = .init(round: 1,
                                            date: Date(),
                                            numbers: PensionNumbers(numbers: [1,2,3,4,5,6,7]),
                                            bonus: PensionNumbers(numbers: [nil,0,9,8,7,6,5]))
}
