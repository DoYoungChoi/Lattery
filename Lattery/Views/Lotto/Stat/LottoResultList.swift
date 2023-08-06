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
                    LottoResultRow(lotto: lotto)
                }
            }
        }
        .listStyle(.inset)
    }
}

struct LottoResultList_Previews: PreviewProvider {
    static var previews: some View {
        LottoResultList()
    }
}
