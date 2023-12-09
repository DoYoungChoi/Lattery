//
//  LottoStatisticsMainView.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import SwiftUI

struct LottoStatisticsMainView: View {
    
    @StateObject var viewModel: LottoStatisticsViewModel
    
    var body: some View {
        ZStack {
            VStack {
                LottoPagePicker(viewModel: viewModel)
                
                switch viewModel.page {
                case .detail:
                    LottoResultListView(viewModel: viewModel)
                case .statistics:
                    LottoStatisticsView(viewModel: viewModel)
                }
            }
            .padding(.horizontal, 20)
            .navigationTitle("로또 정보")
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
                    .onTapGesture {
                        // TODO: 지우기
                        viewModel.phase = .notRequested
                    }
            }
        }
    }
}

private struct LottoPagePicker: View {
    @ObservedObject var viewModel: LottoStatisticsViewModel
    
    fileprivate var body: some View {
        HStack {
            ForEach(LottoPageType.allCases) { pageType in
                Button(pageType.id) {
                    viewModel.send(action: .changePage(pageType))
                }
                .buttonStyle(PickerButtonStyle(isSelected: viewModel.page == pageType))
            }
        }
    }
}

#Preview {
    LottoStatisticsMainView(viewModel: .init())
}
