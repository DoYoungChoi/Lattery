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
    private enum Page: String, CaseIterable, Identifiable {
        case detail = "회차정보"
        case percent = "자리별비율"
        var id: String { rawValue }
    }
    
    var body: some View {
        VStack {
            PensionResultBoard()
            
            Picker("페이지", selection: $page) {
                ForEach(Page.allCases) { page in
                    Text(page.rawValue)
                        .tag(page)
                }
            }
            .pickerStyle(.segmented)
            
            if page == .detail {
                PensionResultList()
            } else if page == .percent {
                PensionRatioGraphView()
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("연금복권 통계")
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
