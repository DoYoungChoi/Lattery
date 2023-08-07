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
    @State private var ascending: Bool = false // descending
    
    var body: some View {
        List {
            HStack {
                Rectangle()
                    .frame(width: 5)
                    .foregroundColor(.backgroundGray)
                
                Toggle("회차 오름차순", isOn: $ascending)
                    .tint(.customPink)
            }
            
            ForEach(lottos) { lotto in
                NavigationLink {
                    LottoResultDetail(lotto: lotto)
                } label: {
                    LottoResultRow(lotto: lotto)
                }
            }
        }
        .listStyle(.inset)
        .onChange(of: ascending) { newValue in
            let order: SortOrder = newValue ? .forward : .reverse
            lottos.sortDescriptors = [SortDescriptor(\.round, order: order)]
        }
    }
}

struct LottoResultList_Previews: PreviewProvider {
    static var previews: some View {
        LottoResultList()
    }
}
