//
//  LottoCombinationView.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct LottoCombinationView: View {
    
    @ObservedObject var viewModel: LottoStatisticsViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            HeadInfoView(viewModel: viewModel)
            
            // TODO: 로또 조합 선택창
            LottoRow(numbers: LottoNumbers(numbers: []),
                     presentEmptyBool: false) {
                viewModel.send(action: .toggleNumberBoard)
            }
            
            List {
                AscendingToggle(isOn: $viewModel.ascending)
                
                ForEach(viewModel.filtered, id:\.round) { lotto in
                    NavigationLink {
                        LottoResultView(lotto: lotto)
                    } label: {
                        LottoCombinationRow(lotto: lotto,
                                            includeBonus: viewModel.includeBonus)
                    }
                }
            }
            .listStyle(.inset)
        }
        .sheet(isPresented: $viewModel.showNumberSheet) {
            LottoNumberSheet(viewModel: .init())
        }
    }
}

private struct HeadInfoView: View {
    
    @ObservedObject var viewModel: LottoStatisticsViewModel
    
    fileprivate var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(verbatim: "총 \(viewModel.lottos.count)회 중 \(viewModel.filtered.count)회")
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


private struct LottoCombinationRow: View {
    
    let lotto: LottoEntity
    let includeBonus: Bool
    
    fileprivate init(lotto: LottoEntity,
                     includeBonus: Bool) {
        self.lotto = lotto
        self.includeBonus = includeBonus
    }
    
    fileprivate var body: some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(Color.gray1)
                .frame(width: 3)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(verbatim: "\(lotto.round)회")
                        .foregroundColor(.primaryColor)
                    
                    Text("(\(lotto.date.toDateStringKor) 추첨)")
                        .foregroundStyle(Color.gray2)
                    
                    Spacer()
                }
                .font(.system(size: 11))
                
                HStack(spacing: 12) {
                    Spacer()
                    ForEach(lotto.numbers, id:\.self) { number in
                        LottoBall(number: number)
                    }
                    
                    if includeBonus {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.gray3)
                        LottoBall(number: Int(lotto.bonus))
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

#Preview {
    LottoCombinationView(viewModel: .init())
}
