//
//  PensionStatisticsMainView.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct PensionStatisticsMainView: View {
    
    @StateObject var viewModel: PensionStatisticsViewModel
    
    var body: some View {
        ZStack {
            VStack {
                PensionPagePicker(viewModel: viewModel)
                    .padding(.horizontal, 20)
                
                switch viewModel.page {
                case .detail:
                    PensionResultListView(viewModel: viewModel)
                case .statistics:
                    PensionStatisticsView(viewModel: viewModel)
                }
            }
            .navigationTitle("연금복권 정보")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.send(action: .fetch)
                    } label: {
                        Image("refresh")
                    }
                }
            }
            
            if viewModel.phase == .loading {
                LoadingView(phase: $viewModel.phase,
                            work: .pension)
            }
        }
    }
}

private struct PensionPagePicker: View {
    @ObservedObject var viewModel: PensionStatisticsViewModel
    
    fileprivate var body: some View {
        HStack {
            ForEach(PensionPageType.allCases) { pageType in
                Button(pageType.id) {
                    viewModel.send(action: .changePage(pageType))
                }
                .buttonStyle(PickerButtonStyle(isSelected: viewModel.page == pageType))
            }
        }
    }
}

#Preview {
    PensionStatisticsMainView(viewModel: .init(services: StubService()))
}
