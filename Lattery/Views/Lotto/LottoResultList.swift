//
//  LottoResultList.swift
//  Lattery
//
//  Created by dodor on 2023/07/07.
//

import SwiftUI

struct LottoResultList: View {
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.round, order: .reverse)
    ]) var lottos: FetchedResults<LottoEntity>
    
    var body: some View {
        List {
            ForEach(lottos) { lotto in
                NavigationLink {
                    LottoResultDetail(lotto: lotto)
                } label: {
                    HStack {
                        Text(verbatim: "\(lotto.round)회")
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
