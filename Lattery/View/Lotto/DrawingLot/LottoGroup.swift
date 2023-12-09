//
//  LottoGroup.swift
//  Lattery
//
//  Created by dodor on 12/6/23.
//

import Foundation

enum LottoGroup: String, CaseIterable, Identifiable, Comparable {
    case a = "A"
    case b = "B"
    case c = "C"
    case d = "D"
    case e = "E"
    
    var id: String { rawValue }
    static func < (lhs: LottoGroup, rhs: LottoGroup) -> Bool {
        lhs.id < rhs.id
    }
}
