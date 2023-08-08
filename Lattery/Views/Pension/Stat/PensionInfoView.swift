//
//  PensionStatView.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import SwiftUI

struct PensionInfoView: View {
    @EnvironmentObject var data: PensionData
    @State private var isFetching: Bool = false
    @State private var pensions: [Pension] = []
    @State private var page: InfoPage = .detail

    var body: some View {
        VStack {
            InfoPagePicker(selection: $page)
            
            if page == .detail {
                PensionResultList()
                    .padding(.leading, -15)
            } else if page == .stat {
                PensionStatMenuView()
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("연금복권 정보")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PensionStatView_Previews: PreviewProvider {
    static var previews: some View {
        PensionInfoView()
    }
}
