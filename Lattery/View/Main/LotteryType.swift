//
//  LotteryType.swift
//  Lattery
//
//  Created by dodor on 12/14/23.
//

import Foundation

enum LotteryType: String, Identifiable, CaseIterable {
    case lotto = "로또 6/45"
    case pension = "연금복권720+"
    
    var id: String { rawValue }
}
