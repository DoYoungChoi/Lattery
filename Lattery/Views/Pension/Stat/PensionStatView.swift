//
//  PensionStatView.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import SwiftUI

struct PensionStatView: View {
    @EnvironmentObject var data: PensionData
    @State private var isFetching: Bool = false
    @State private var pensions: [Pension] = []
    @State private var page: Page = .detail

    var body: some View {
        VStack {
            PensionResultBoard()
            
            PagePicker(selection: $page)
            
            if page == .detail {
                PensionResultList()
                    .padding(.leading, -15)
            } else if page == .stat {
                PensionRatioGraphView()
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("연금복권 정보")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                } label: {
                    Label("발바닥", systemImage: isFetching ? "pawprint" : "pawprint.fill")
                }
            }
        }
    }
}

struct PensionStatView_Previews: PreviewProvider {
    static var previews: some View {
        PensionStatView()
    }
}
