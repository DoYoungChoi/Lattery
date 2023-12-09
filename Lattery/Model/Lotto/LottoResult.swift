//
//  LottoResult.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import Foundation

struct LottoResult: Identifiable {
    var id: Int { round }
    var round: Int
    var numbers: LottoNumbers
    var date: Date
    var winnings: Int64 // 1등 당첨금
    var winnerCount: Int // 1등 당첨자 수
    var totalSalePrice: Int64? // 총 판매금액
}

