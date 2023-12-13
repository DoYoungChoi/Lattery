//
//  PensionStatisticsView.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct PensionStatisticsView: View {
    
    @ObservedObject var viewModel: PensionStatisticsViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            PensionStatisticsTypePicker(viewModel: viewModel)
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
            if viewModel.pensions.count < 1 {
                EmptyPensionDataView()
            } else {
                switch viewModel.statType {
                case .color:
                    PensionRatioView(viewModel: viewModel)
                        .padding(.horizontal, 20)
                case .combination:
                    PensionCombinationView(viewModel: viewModel)
                }
            }
        }
    }
}

private struct PensionStatisticsTypePicker: View {
    
    @ObservedObject var viewModel: PensionStatisticsViewModel
    
    fileprivate var body: some View {
        HStack {
            ForEach(PensionStatisticsType.allCases) { statType in
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
    PensionStatisticsView(viewModel: .init(services: StubService()))
}
