//
//  LottoStatisticsView.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct LottoStatisticsView: View {
    
    @ObservedObject var viewModel: LottoStatisticsViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            LottoStatisticsTypePicker(viewModel: viewModel)
                .padding(.horizontal, 20)
            
            contentView
            
            Spacer()
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .loading:
            EmptyView()
        case .notRequested, .success, .fail:
            if viewModel.lottos.count < 1 {
                EmptyLottoDataView()
            } else {
                switch viewModel.statType {
                case .count:
                    LottoCountView(viewModel: viewModel)
                        .padding(.horizontal, 20)
                case .color:
                    LottoRatioView(viewModel: viewModel)
                        .padding(.horizontal, 20)
                case .combination:
                    LottoCombinationView(viewModel: viewModel)
                }
            }
        }
    }
}

private struct LottoStatisticsTypePicker: View {
    
    @ObservedObject var viewModel: LottoStatisticsViewModel
    
    fileprivate var body: some View {
        HStack {
            ForEach(LottoStatisticsType.allCases) { statType in
                Button(statType.rawValue) {
                    viewModel.send(action: .changeType(statType))
                }
                .buttonStyle(CustomFitButtonStyle(isSelected: viewModel.statType == statType,
                                                  color: .gray2))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    LottoStatisticsView(viewModel: .init(services: StubService()))
}
