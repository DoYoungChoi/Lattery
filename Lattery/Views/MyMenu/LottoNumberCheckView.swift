//
//  LottoNumberCheckView.swift
//  Lattery
//
//  Created by dodor on 2023/08/09.
//

import SwiftUI

struct LottoWin {
    var numbers: [Int16]
    var bonus: Int16 = 0
    
    static let example = LottoWin(numbers: [1, 11, 21, 31, 41, 45], bonus: 9)
}

struct LottoNumberCheckView: View {
    var entity: LottoResult
    var winInfo: LottoEntity?
    private var winNumbers: LottoWin {
        guard let lotto = winInfo else { return LottoWin(numbers: Array(repeating: 0, count: 6))}
        return LottoWin(numbers: [lotto.no1, lotto.no2, lotto.no3, lotto.no4, lotto.no5, lotto.no6],
                        bonus: lotto.noBonus)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Divider()
                ForEach([entity.aGroup, entity.bGroup, entity.cGroup, entity.dGroup, entity.eGroup], id:\.self) { numberString in
                    LottoNumberCheckRow(lottoWin: winNumbers, numberString: numberString ?? "")
                        .padding(.vertical, 10)
                    Divider()
                }
            }
        }
    }
}
