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
        if lottos.count > 0 {
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
        } else {
            Text("로또 데이터가 없습니다.\n새로고침 버튼을 눌러 데이터를 가져오세요.")
                .multilineTextAlignment(.center)
                .foregroundColor(.customGray)
                .padding(.vertical)
        }
    }
}

struct LottoResultList_Previews: PreviewProvider {
    static var previews: some View {
        LottoResultList()
    }
}
