//
//  LottoInfoView.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import SwiftUI

struct LottoInfoView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var data: LottoData
    @State private var isFetching: Bool = false
    @State private var page: InfoPage = .detail
    
    var body: some View {
        VStack {
            InfoPagePicker(selection: $page)
                
            if page == .detail {
                LottoResultList()
                    .padding(.leading, -15)
            } else if page == .stat {
                LottoStatMenuView()
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("로또 정보")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct LottoInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        LottoStatView()
//    }
//}
