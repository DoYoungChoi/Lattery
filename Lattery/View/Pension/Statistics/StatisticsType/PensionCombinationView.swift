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
                .padding(.horizontal, 20)
            
            // TODO: 로또 조합 선택창
            PensionRow(numbers: PensionNumbers(numbers: viewModel.fixedNumbers)) {
                viewModel.send(action: .toggleNumberBoard)
            }
            .padding(.horizontal, 20)
            
            List {
                AscendingToggle(isOn: $viewModel.ascending)

                ForEach(viewModel.filtered) { pension in
                    NavigationLink {
                        PensionResultView(pension: pension)
                            .padding(.horizontal, 20)
                    } label: {
                        PensionCombinationRow(pension: pension,
                                              includeBonus: viewModel.includeBonus,
                                              fixedNumbers: viewModel.fixedNumbers ?? [])
                    }
                }
            }
            .listStyle(.inset)
        }
        .sheet(isPresented: $viewModel.showNumberSheet) {
            if #available(iOS 16.0, *) {
                PensionNumberSheet(fixedNumbers: $viewModel.fixedNumbers)
                    .presentationDetents([.fraction(0.7)])
            } else {
                PensionNumberSheet(fixedNumbers: $viewModel.fixedNumbers)
            }
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
    let fixedNumbers: [Int?]
    
    private var winNumbers: [Int?] {
        pension.numbers.toPensionNumbers
    }
    private var bonusNumbers: [Int?] {
        let count = pension.bonus.toPensionNumbers.count
        return Array(pension.bonus.toPensionNumbers[1..<count])
    }
    
    fileprivate init(pension: PensionEntity,
                     includeBonus: Bool,
                     fixedNumbers: [Int?]) {
        self.pension = pension
        self.includeBonus = includeBonus
        self.fixedNumbers = fixedNumbers
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
                HStack(spacing: 4) {
                    Text("1등")
                        .foregroundStyle(Color.primaryColor)
                    Spacer()
                    ForEach(Array(winNumbers.enumerated()), id:\.offset) { (index, number) in
                        PensionBall(position: index,
                                    number: number ?? -1,
                                    fixed: fixedNumbers[index] == number)
                        if index == 0 {
                            Text("조")
                                .font(.subheadline)
                                .foregroundStyle(Color.primaryColor)
                        }
                    }
                }
                .font(.system(size: 13))
                
                if includeBonus {
                    // 보너스
                    HStack(spacing: 4) {
                        Text("보너스")
                            .foregroundStyle(Color.primaryColor)
                        Spacer()
                        Text("각 조")
                            .font(.subheadline)
                            .foregroundStyle(Color.primaryColor)
                        ForEach(Array(bonusNumbers.enumerated()), id:\.offset) { (index, number) in
                            PensionBall(position: index+1,
                                        number: number ?? -1,
                                        fixed: fixedNumbers[index+1] == number)
                        }
                    }
                    .font(.system(size: 13))
                }
            }
        }
    }
}

#Preview {
    PensionCombinationView(viewModel: .init(services: StubService()))
}
