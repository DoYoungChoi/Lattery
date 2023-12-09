//
//  PensionResultObject.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import Foundation

struct PensionResultObject: Codable, Identifiable {
    var id: UUID { UUID() }
    var rows1: [Row] // 보너스 당첨 정보
    var rows2: [Row] // 주 당첨 정보
    var rows: [Row]
}

extension PensionResultObject {
    struct Row: Codable {
        var round: String // 연금복권 회차
        var rank: String? // 등위
        var drawDate: String // 맞지 않는 날짜
        var rankClass: String // 당첨조
        var rankNo: String // 당첨번호
        var pensionDrawDate: String // 추첨날짜 yyyy-MM-dd
    }
}

extension PensionResultObject {
    func toModel() -> PensionResult? {
        guard let win = self.rows2.filter({ $0.rank == "1" }).first,
              let round = Int(win.round),
              let date = win.pensionDrawDate.toDate,
              let group = Int(win.rankClass),
              let bonus = self.rows1.first
        else { return nil }
        
        return PensionResult(round: round,
                             date: date,
                             group: group,
                             numbers: win.rankNo,
                             bonus: bonus.rankNo)
    }
}
