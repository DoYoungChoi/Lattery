//
//  PensionRatioView.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct PensionRatioView: View {
    
    @ObservedObject var viewModel: PensionStatisticsViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            HeadInfoView(viewModel: viewModel)
            
            GraphInfoView(colorSet: viewModel.colorSet)
            
            PensionRatioTypePicker(viewModel: viewModel)
            
            Text("[단위: %]")
                .font(.footnote)
                .foregroundStyle(Color.gray2)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            switch viewModel.ratioType {
            case .total:
                PensionPieChart(viewModel: viewModel)
            case .position:
                PensionPositionChart(viewModel: viewModel)
            }
        }
    }
}

private struct HeadInfoView: View {
    
    @ObservedObject var viewModel: PensionStatisticsViewModel
    
    fileprivate var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(verbatim: "총 \(viewModel.pensions.count)회")
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
                HStack(spacing: 4) {
                    Image(systemName: "square.fill")
                        .resizable()
                        .foregroundColor(color)
                        .frame(width: 14, height: 14)
                    Text("\(index)")
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .font(.system(size: 13))
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.backgroundGray)
        }
    }
}

private struct PensionRatioTypePicker: View {
    
    @ObservedObject var viewModel: PensionStatisticsViewModel
    
    fileprivate var body: some View {
        HStack {
            ForEach(PensionStatisticsViewModel.RatioType.allCases) { type in
                Button(type.rawValue) {
                    viewModel.send(action: .changeRatioType(type))
                }
                .buttonStyle(PickerButtonStyle(isSelected: viewModel.ratioType == type))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct PensionPieChart: View {
    
    @ObservedObject var viewModel: PensionStatisticsViewModel
    
    fileprivate var body: some View {
        GeometryReader { _ in
            PieChart(data: viewModel.totalRatioData)
                .padding(.top, 16)
        }
    }
}

private struct PensionPositionChart: View {
    
    @ObservedObject var viewModel: PensionStatisticsViewModel
    
    fileprivate var body: some View {
        HStack {
            HStack {
                RatioBarGraph(data: viewModel.positionRatioData[0])
                RatioBarGraph(data: viewModel.positionRatioData[1])
                RatioBarGraph(data: viewModel.positionRatioData[2])
                RatioBarGraph(data: viewModel.positionRatioData[3])
                RatioBarGraph(data: viewModel.positionRatioData[4])
                RatioBarGraph(data: viewModel.positionRatioData[5])
                RatioBarGraph(data: viewModel.positionRatioData[6])
            }
        }
    }
}

#Preview {
    PensionRatioView(viewModel: .init())
}
