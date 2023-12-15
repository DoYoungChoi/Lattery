//
//  LottoWinningCheckView.swift
//  Lattery
//
//  Created by dodor on 12/7/23.
//

import SwiftUI

struct LottoWinningCheckView: View {
    
    @StateObject var viewModel: LottoWinningCheckViewModel
    @Binding var phase: Phase
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 8) {
                Image(systemName: "speaker.wave.2")
                Text("매주 토요일 오후 8시 35분경 발표")
                Spacer()
            }
            .foregroundColor(.gray1)
            
            SelectedLottoResult(viewModel: viewModel)
            SelectedDrawingLotResult(viewModel: viewModel)
            Spacer()
        }
        .onChange(of: phase) { newValue in
            if newValue == .success {
                self.viewModel.getLottoEntities()
                self.phase = .notRequested
            }
        }
    }
}

private struct SelectedLottoResult: View {
    
    @ObservedObject var viewModel: LottoWinningCheckViewModel
    
    fileprivate var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("로또 회차")
                    .font(.headline)
                
                Spacer()
                
                if viewModel.lottos.count > 0 {
                    Picker("", selection: $viewModel.selectedLotto) {
                        ForEach(viewModel.lottos) { lotto in
                            Text(verbatim: "\(lotto.round)회")
                                .tag(Optional(lotto))
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.gray2)
                } else {
                    Text("데이터가 없습니다")
                        .font(.subheadline)
                        .foregroundColor(.gray2)
                }
            }
            
            Group {
                if viewModel.winningNumbers.count == 6 {
                    resultBoard
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                } else {
                    VStack {
                        Spacer()
                        EmptyLottoDataView()
                        Spacer()
                    }
                    .frame(maxHeight: 150)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.backgroundGray)
            .cornerRadius(10)
        }
    }
    
    var resultBoard: some View {
        VStack(spacing: 4) {
            Text(verbatim: "\(viewModel.selectedLotto!.round)회 당첨결과")
                .font(.title)
                .bold()
                .foregroundStyle(Color.primaryColor)
            
            Text("(\(viewModel.selectedLotto!.date.toDateStringKor) 추첨)")
                .font(.caption)
                .foregroundStyle(Color.gray2)
            
            HStack(alignment: .top, spacing: 4) {
                VStack(spacing: 4) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.winningNumbers, id:\.self) { number in
                            LottoBall(number: number)
                        }
                    }
                    .padding(8)
                    .background(Color.pureBackground)
                    .cornerRadius(10)
                    
                    Text("당첨번호")
                        .font(.caption)
                        .foregroundStyle(Color.primaryColor)
                }
                
                Image(systemName: "plus")
                    .foregroundColor(.gray2)
                    .padding(.top, 16)
                
                VStack(spacing: 4) {
                    HStack(spacing: 8) {
                        LottoBall(number: viewModel.bonus)
                    }
                    .padding(8)
                    .background(Color.pureBackground)
                    .cornerRadius(10)
                    
                    Text("보너스")
                        .font(.caption)
                        .foregroundStyle(Color.primaryColor)
                }
            }
        }
    }
}

private struct SelectedDrawingLotResult: View {
    
    @ObservedObject var viewModel: LottoWinningCheckViewModel
    
    fileprivate var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                HStack {
                    Text("저장한 추첨번호")
                        .font(.headline)
                        .foregroundStyle(Color.primaryColor)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    if viewModel.drawingLotResults.count > 0 {
                        Picker("", selection: $viewModel.selectedResult) {
                            ForEach(viewModel.drawingLotResults, id: \.self) { result in
                                Text("\(result.date.toDateTimeKor) 추첨번호")
                                    .tag(Optional(result))
                            }
                        }
                        .tint(.gray2)
                        .pickerStyle(.menu)
                    } else {
                        Text("데이터가 없습니다")
                            .font(.subheadline)
                            .foregroundColor(.gray2)
                    }
                }
            }
            
            if viewModel.selectedResult != nil {
                compareBoard
            }
        }
    }
    
    var compareBoard: some View {
        ScrollView {
            Divider()
            VStack(spacing: 8) {
                ForEach(viewModel.resultNumbers, id:\.self) { number in
                    CheckRow(viewModel: viewModel,
                             number: number)
                    Divider()
                }
            }
        }
    }
}

private struct CheckRow: View {
    
    @ObservedObject var viewModel: LottoWinningCheckViewModel
    let number: LottoNumbers
    
    private var rank: String {
        let include: [Int] = viewModel.winningNumbers.filter({ number.numbers.contains($0) })
        if include.count == 6 {
            return "1등🥇"
        } else if include.count == 5 && number.numbers.contains(viewModel.bonus) {
            return "2등🥈"
        } else if include.count == 5 {
            return "3등🥉"
        } else if include.count == 4 {
            return "4등"
        } else if include.count == 3 {
            return "5등"
        } else {
            return "낙첨"
        }
    }
    
    fileprivate init(viewModel: LottoWinningCheckViewModel,
                     number: LottoNumbers) {
        self.viewModel = viewModel
        self.number = number
    }
    
    fileprivate var body: some View {
        HStack {
            Text(rank)
                .multilineTextAlignment(.center)
                .font(.headline)
                .frame(maxWidth: 44)
                .padding(.trailing, 16)
            
            HStack(spacing: 8) {
                ForEach(number.numbers, id:\.self) { number in
                    LottoBall(number: number,
                              fixed: viewModel.winningNumbers.contains(number))
                }
            }
        }
    }
}

#Preview {
    LottoWinningCheckView(viewModel: .init(services: StubService()),
                          phase: .constant(.notRequested))
}
