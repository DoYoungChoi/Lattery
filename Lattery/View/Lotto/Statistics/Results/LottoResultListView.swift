//
//  LottoResultListView.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct LottoResultListView: View {
    
    @ObservedObject var viewModel: LottoStatisticsViewModel
    
    var body: some View {
        if viewModel.lottos.count < 1 {
            EmptyLottoDataView()
        } else {
            List {
                AscendingToggle(isOn: $viewModel.ascending)
                
                contentView
            }
            .listStyle(.inset)
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .loading:
            EmptyView()
        default:
            ForEach(viewModel.lottos) { lotto in
                NavigationLink {
                    LottoResultView(lotto: lotto)
                        .padding(.horizontal, 20)
                } label: {
                    LottoResultRow(lotto: lotto)
                }
            }
        }
    }
}

private struct LottoResultRow: View {
    
    let lotto: LottoEntity
    
    fileprivate var body: some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(Color.gray1)
                .frame(width: 3)
            
            Text(verbatim: "\(lotto.round)회")
                .font(.headline)
                .foregroundColor(.primaryColor)
            
            Text("(\(lotto.date.toDateStringKor) 추첨)")
                .font(.subheadline)
                .foregroundStyle(Color.gray2)
        }
    }
}

#Preview {
    LottoResultListView(viewModel: .init(services: StubService()))
}
