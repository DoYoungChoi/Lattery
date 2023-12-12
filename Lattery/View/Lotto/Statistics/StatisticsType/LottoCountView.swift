//
//  LottoCountView.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct LottoCountView: View {
    
    @ObservedObject var viewModel: LottoStatisticsViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            HeadInfoView(viewModel: viewModel)
            
            // TODO: lottos에서 나온 Bar Graph 데이터
            LottoBarGraph(data: viewModel.countData)
        }
    }
}

private struct HeadInfoView: View {
    
    @ObservedObject var viewModel: LottoStatisticsViewModel
    
    fileprivate var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(verbatim: "총 \(viewModel.lottos.count)회")
                .font(.headline)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Button {
                    viewModel.send(action: .toggleIncludeBonus)
                } label: {
                    Label(
                        title: { Text("보너스 포함") },
                        icon: {
                            Image(systemName: viewModel.includeBonus ? "checkmark.square.fill" : "checkmark.square")
                                .renderingMode(.template)
                                .foregroundColor(.accentColor)
                        }
                    )
                }
                .buttonStyle(.plain)
                
                Picker("순서", selection: $viewModel.countMode) {
                    ForEach(LottoStatisticsViewModel.CountMode.allCases) { mode in
                        Text(mode.id)
                            .tag(mode)
                    }
                }
                .tint(.gray2)
                .pickerStyle(.menu)
            }
        }
    }
}

private struct LottoBarGraph: View {
    
    let data: [GraphData]
    
    fileprivate var body: some View {
        BarGraph(data: data,
                 axis: .horizontal)
        .padding(.bottom)
    }
}

#Preview {
    LottoCountView(viewModel: .init(services: StubService()))
}
