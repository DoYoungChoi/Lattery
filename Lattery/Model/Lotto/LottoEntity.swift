//
//  LottoEntity.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import Foundation

struct LottoEntity: Identifiable, Hashable {
    var id: Int16 { round }
    var round: Int16
    var date: Date
    var numbers: [Int]
    var bonus: Int16
    var winnings: Int64
    var totalSalePrice: Int64
    var winnerCount: Int16
}
