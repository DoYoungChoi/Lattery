//
//  LottoResultDetail.swift
//  Lattery
//
//  Created by dodor on 2023/07/09.
//

import SwiftUI

struct LottoResultDetail: View {
    var lotto: LottoEntity
    
    var body: some View {
        VStack {
            HStack {
                Text(verbatim: "\(lotto.nth)회")
                LottoBall(number: Int(lotto.no1))
                LottoBall(number: Int(lotto.no2))
                LottoBall(number: Int(lotto.no3))
                LottoBall(number: Int(lotto.no4))
                LottoBall(number: Int(lotto.no5))
                LottoBall(number: Int(lotto.no6))
                Image(systemName: "plus")
                LottoBall(number: Int(lotto.noBonus))
            }
        }
    }
}

//struct LottoResultDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        LottoResultDetail(lotto: LottoEntity(context: M))
//    }
//}
