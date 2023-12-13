//
//  PensionResultListView.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct PensionResultListView: View {
    
    @ObservedObject var viewModel: PensionStatisticsViewModel
    
    var body: some View {
        if viewModel.pensions.count < 1 {
            EmptyPensionDataView()
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
            ForEach(viewModel.pensions) { pension in
                NavigationLink {
                    PensionResultView(pension: pension)
                        .padding(.horizontal, 20)
                } label: {
                    PensionResultRow(pension: pension)
                }
            }
        }
    }
}

private struct PensionResultRow: View {
    
    let pension: PensionEntity
    
    fileprivate var body: some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(Color.gray1)
                .frame(width: 3)
            
            Text(verbatim: "\(pension.round)회")
                .font(.headline)
                .foregroundColor(.primaryColor)
            
            Text("(\(pension.date.toDateStringKor) 추첨)")
                .font(.subheadline)
                .foregroundStyle(Color.gray2)
        }
    }
}

#Preview {
    PensionResultListView(viewModel: .init(services: StubService()))
}
