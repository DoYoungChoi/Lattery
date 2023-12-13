//
//  LottoPieView.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct LottoRatioView: View {
    
    @ObservedObject var viewModel: LottoStatisticsViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            HeadInfoView(viewModel: viewModel)
            
            GraphInfoView(colorSet: viewModel.colorSet)
            
            LottoRatioTypePicker(viewModel: viewModel)
            
            Text("[단위: %]")
                .font(.footnote)
                .foregroundStyle(Color.gray2)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            switch viewModel.ratioType {
            case .total:
                LottoPieChart(viewModel: viewModel)
            case .position:
                LottoPositionChart(viewModel: viewModel)
            }
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
        }
    }
}

private struct GraphInfoView: View {
    
    let colorSet: [Color]
    
    fileprivate init(colorSet: [Color]) {
        self.colorSet = colorSet
    }
    
    fileprivate var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(colorSet.enumerated()), id: \.offset) { (index, color) in
                let startNumber = 10 * index + 1
                HStack(spacing: 4) {
                    Image(systemName: "square.fill")
                        .resizable()
                        .foregroundColor(color)
                        .frame(width: 16, height: 16)
                    Text("\(startNumber)~\(startNumber > 40 ? 45 : startNumber + 9)")
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .font(.system(size: 12))
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.backgroundGray)
        }
    }
}

private struct LottoRatioTypePicker: View {
    
    @ObservedObject var viewModel: LottoStatisticsViewModel
    
    fileprivate var body: some View {
        HStack {
            ForEach(LottoStatisticsViewModel.RatioType.allCases) { type in
                Button(type.rawValue) {
                    viewModel.send(action: .changeRatioType(type))
                }
                .buttonStyle(PickerButtonStyle(isSelected: viewModel.ratioType == type))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct LottoPieChart: View {
    
    @ObservedObject var viewModel: LottoStatisticsViewModel
    
    fileprivate var body: some View {
        GeometryReader { _ in
            PieChart(data: viewModel.totalRatioData)
                .padding(.top, 20)
        }
    }
}

private struct LottoPositionChart: View {
    
    @ObservedObject var viewModel: LottoStatisticsViewModel
    
    fileprivate var body: some View {
        HStack {
            RatioBarGraph(data: viewModel.positionRatioData[0])
            RatioBarGraph(data: viewModel.positionRatioData[1])
            RatioBarGraph(data: viewModel.positionRatioData[2])
            RatioBarGraph(data: viewModel.positionRatioData[3])
            RatioBarGraph(data: viewModel.positionRatioData[4])
            RatioBarGraph(data: viewModel.positionRatioData[5])
            if viewModel.includeBonus {
                Image(systemName: "plus")
                    .foregroundColor(.gray3)
                RatioBarGraph(data: viewModel.positionRatioData[6])
            }
        }
    }
}

#Preview {
    LottoRatioView(viewModel: .init(services: StubService()))
}
