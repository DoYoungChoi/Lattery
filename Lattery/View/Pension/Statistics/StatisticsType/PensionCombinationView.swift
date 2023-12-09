//
//  PensionCombinationView.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct PensionCombinationView: View {
    
    @ObservedObject var viewModel: PensionStatisticsViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            HeadInfoView(viewModel: viewModel)
            
            // TODO: 로또 조합 선택창
            PensionRow(numbers: []) {
                viewModel.send(action: .toggleNumberBoard)
            }
            
            List {
                AscendingToggle(isOn: $viewModel.ascending)

                ForEach(viewModel.filtered) { pension in
                    NavigationLink {
                        PensionResultView(pension: pension)
                    } label: {
                        PensionCombinationRow(pension: pension,
                                              includeBonus: viewModel.includeBonus)
                    }
                }
            }
            .listStyle(.inset)
        }
        .sheet(isPresented: $viewModel.showNumberSheet) {
            PensionNumberSheet(viewModel: .init())
        }
    }
}

private struct HeadInfoView: View {
    
    @ObservedObject var viewModel: PensionStatisticsViewModel
    
    fileprivate var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(verbatim: "총 \(viewModel.pensions.count)회 중 \(viewModel.filtered.count)회")
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

private struct PensionCombinationRow: View {
    
    let pension: PensionEntity
    let includeBonus: Bool
    private var winNumbers: String {
        pension.numbers
    }
    private var bonusNumbers: String {
        pension.bonus
    }
    
    fileprivate init(pension: PensionEntity,
                     includeBonus: Bool) {
        self.pension = pension
        self.includeBonus = includeBonus
    }
    
    fileprivate var body: some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(Color.gray1)
                .frame(width: 3)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(verbatim: "\(pension.round)회")
                        .foregroundColor(.primaryColor)
                    
                    Text("(\(pension.date.toDateStringKor) 추첨)")
                        .foregroundStyle(Color.gray2)
                    
                    Spacer()
                }
                .font(.system(size: 11))
                
                // 1등
                HStack(spacing: 8) {
                    Text("1등")
                        .foregroundStyle(Color.primaryColor)
                    Spacer()
                    PensionBall(position: 0,
                                number: Int(pension.group))
                    Text("조")
                        .foregroundStyle(Color.primaryColor)
                    ForEach(Array(winNumbers.enumerated()), id:\.offset) { (index, number) in
                        PensionBall(position: index + 1,
                                    number: Int(String(number)) ?? -1)
                    }
                }
                .font(.caption2)
                
                if includeBonus {
                    // 보너스
                    HStack(spacing: 8) {
                        Text("보너스")
                            .foregroundStyle(Color.primaryColor)
                        Spacer()
                        Text("각 조")
                            .foregroundStyle(Color.primaryColor)
                        ForEach(Array(bonusNumbers.enumerated()), id:\.offset) { (index, number) in
                            PensionBall(position: index + 1,
                                        number: Int(String(number)) ?? -1)
                        }
                    }
                    .font(.caption2)
                }
            }
        }
    }
}

#Preview {
    PensionCombinationView(viewModel: .init())
}
