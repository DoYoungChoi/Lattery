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
                
                switch viewModel.page {
                case .detail:
                    PensionResultListView(viewModel: viewModel)
                case .statistics:
                    PensionStatisticsView(viewModel: viewModel)
                }
            }
            .padding(.horizontal, 20)
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
                LoadingView()
                    .ignoresSafeArea(edges: .vertical)
                    .onTapGesture {
                        // TODO: 지우기
                        viewModel.phase = .notRequested
                    }
            }
        }
    }
}

private struct PensionPagePicker: View {
    @ObservedObject var viewModel: PensionStatisticsViewModel
    
    fileprivate var body: some View {
        HStack {
            ForEach(PensionPageType.allCases) { pageType in
                Button(pageType.rawValue) {
                    viewModel.send(action: .changePage(pageType))
                }
                .buttonStyle(PickerButtonStyle(isSelected: viewModel.page == pageType))
            }
        }
    }
}

#Preview {
    PensionStatisticsMainView(viewModel: .init())
}
