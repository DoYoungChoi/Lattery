//
//  LottoResultRow.swift
//  Lattery
//
//  Created by dodor on 2023/08/03.
//

import SwiftUI

struct LottoResultRow: View {
    var lotto: LottoEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(verbatim: "\(lotto.round)회")
                .bold()
            HStack {
                LottoBall(number: lotto.no1)
                LottoBall(number: lotto.no2)
                LottoBall(number: lotto.no3)
                LottoBall(number: lotto.no4)
                LottoBall(number: lotto.no5)
                LottoBall(number: lotto.no6)
                Image(systemName: "plus")
                LottoBall(number: lotto.noBonus)
            }
        }
    }
}

//struct LottoResultRow_Previews: PreviewProvider {
//    static var previews: some View {
//        LottoResultRow()
//    }
//}
