//
//  Lotto.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import Foundation

struct LottoResultObject: Codable {
    var id: UUID { UUID() }
    var returnValue: String // success, fail
    
    var drwNo: Int? // 로또 회차
    var drwNoDate: String? // 로또 발표 날짜 yyyy-MM-dd
    var firstWinamnt: Int64? // 1등 당첨금
    var firstPrzwnerCo: Int? // 1등 당첨자 수
    var totSellamnt: Int64? // 총 판매금액
    
    var drwtNo1: Int?
    var drwtNo2: Int?
    var drwtNo3: Int?
    var drwtNo4: Int?
    var drwtNo5: Int?
    var drwtNo6: Int?
    var bnusNo: Int?
}

extension LottoResultObject {
    func toModel() -> LottoResult? {
        guard let drwNo,
              let drwNoDate, let date = drwNoDate.toDate,
              let firstWinamnt,
              let firstPrzwnerCo,
              let totSellamnt,
              let drwtNo1,
              let drwtNo2,
              let drwtNo3,
              let drwtNo4,
              let drwtNo5,
              let drwtNo6
        else {
            return nil
        }
              
        return .init(round: drwNo,
                     numbers: LottoNumbers(numbers: [drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6],
                                           bonus: bnusNo),
                     date: date,
                     winnings: firstWinamnt,
                     winnerCount: firstPrzwnerCo,
                     totalSalePrice: totSellamnt)
    }
}
