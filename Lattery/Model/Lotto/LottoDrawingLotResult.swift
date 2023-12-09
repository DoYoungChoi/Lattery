//
//  LottoDrawingLotResult.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import Foundation

struct LottoDrawingLotResult: Hashable {
    var date: Date
    var data: [LottoGroup: LottoNumbers]
}
