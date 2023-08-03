//
//  Lotto.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import Foundation

struct Lotto: Codable, Identifiable {
    var id: UUID { UUID() }
    var returnValue: String // success, fail
    
    var drwNo: Int? // 로또 회차
    var drwNoDate: String? // 로또 발표 날짜 yyyy-MM-dd
    var firstWinamnt: Int64? // 1등 당첨금
    var firstPrzwnerCo: Int? // 1등 당첨자 수
    
    var drwtNo1: Int?
    var drwtNo2: Int?
    var drwtNo3: Int?
    var drwtNo4: Int?
    var drwtNo5: Int?
    var drwtNo6: Int?
    var bnusNo: Int?
}
