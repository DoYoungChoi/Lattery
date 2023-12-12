//
//  LottoDrawingLotResult.swift
//  Lattery
//
//  Created by dodor on 12/12/23.
//

import Foundation

struct LottoDrawingLotResult: Identifiable, Hashable {
    let id: String
    let date: Date
    let numbers: [LottoNumbers]
}
