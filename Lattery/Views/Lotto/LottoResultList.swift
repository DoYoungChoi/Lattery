//
//  LottoResultList.swift
//  Lattery
//
//  Created by dodor on 2023/07/07.
//

import SwiftUI

struct LottoResultList: View {
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.nth, order: .reverse)
    ]) var lottos: FetchedResults<LottoEntity>
    
    var body: some View {
        List {
            ForEach(lottos) { lotto in
                NavigationLink {
                    LottoResultDetail(lotto: lotto)
                } label: {
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
        .listStyle(.inset)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white.opacity(0.5))
        }
    }
}

struct LottoResultList_Previews: PreviewProvider {
    static var previews: some View {
        LottoResultList()
    }
}
