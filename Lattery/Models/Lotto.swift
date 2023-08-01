//
//  Lotto.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import Foundation
import CoreData

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
    
    func toEntity(context: NSManagedObjectContext) -> LottoEntity? {
        guard let round = self.drwNo else { return nil }
        
        let lotto = LottoEntity(context: context)
        lotto.round = Int16(self.drwNo ?? round)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        lotto.date = formatter.date(from: self.drwNoDate ?? "")
        lotto.winnerCount = Int16(self.firstPrzwnerCo ?? 0)
        lotto.winnerReward = self.firstWinamnt ?? 0
        lotto.no1 = Int16(self.drwtNo1 ?? 0)
        lotto.no2 = Int16(self.drwtNo2 ?? 0)
        lotto.no3 = Int16(self.drwtNo3 ?? 0)
        lotto.no4 = Int16(self.drwtNo4 ?? 0)
        lotto.no5 = Int16(self.drwtNo5 ?? 0)
        lotto.no6 = Int16(self.drwtNo6 ?? 0)
        lotto.noBonus = Int16(self.bnusNo ?? 0)
        return lotto
    }
}
