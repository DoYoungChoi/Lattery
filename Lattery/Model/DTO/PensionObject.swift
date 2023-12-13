//
//  PensionResultObject.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import Foundation

struct PensionObject: Codable, Identifiable {
    var id: UUID { UUID() }
    var rows1: [Row] // 보너스 당첨 정보
    var rows2: [Row] // 주 당첨 정보
    var rows: [Row]
}

extension PensionObject {
    struct Row: Codable {
        var round: String // 연금복권 회차
        var rank: String? // 등위
        var drawDate: String // 맞지 않는 날짜
        var rankClass: String // 당첨조
        var rankNo: String // 당첨번호
        var pensionDrawDate: String // 추첨날짜 yyyy-MM-dd
    }
}

extension PensionObject {
    func toModel() -> PensionResult? {
        guard let winInfo = rows2.filter({ $0.rank == "1" }).first,
              let round = Int(winInfo.round),
              let date = winInfo.pensionDrawDate.toPensionDate,
              let winGroup = Int(winInfo.rankClass),
              let bonusString = rows1.first?.rankNo
        else { return nil }
        
        let numbers = winInfo.rankNo.map({ Int(String($0)) })
        let bonus = bonusString.map({ Int(String($0)) })
        guard numbers.filter({ $0 != nil }).count == 6,
              bonus.filter({ $0 != nil }).count == 6
        else { return nil }
        
        return PensionResult(round: round,
                             date: date,
                             numbers: PensionNumbers(numbers: [winGroup] + numbers),
                             bonus: PensionNumbers(numbers: [nil] + bonus))
    }
}
