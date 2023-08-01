//
//  Pension720.swift
//  Lattery
//
//  Created by dodor on 2023/07/15.
//

import Foundation

struct Pension: Codable, Identifiable {
    var id: UUID { UUID() }
    var rows1: [PensionRow] // 보너스 당첨 정보
    var rows2: [PensionRow] // 주 당첨 정보
    var rows: [PensionRow]
}

struct PensionRow: Codable {
    var round: String // 연금복권 회차
    var rank: String? // 등위
    var drawDate: String // 맞지 않는 날짜
    var rankClass: String // 당첨조
    var rankNo: String // 당첨번호
    var pensionDrawDate: String // 추첨날짜 yyyy-MM-dd
}
