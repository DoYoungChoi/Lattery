//
//  PensionWinningCheckView.swift
//  Lattery
//
//  Created by dodor on 12/7/23.
//

import SwiftUI

struct PensionWinningCheckView: View {
    
    @StateObject var viewModel: PensionWinningCheckViewModel
    @Binding var phase: Phase
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 8) {
                Image(systemName: "speaker.wave.2")
                Text("매주 목요일 오후 7시 5분경 발표")
                Spacer()
            }
            .foregroundColor(.gray1)
            
            SelectedPensionResult(viewModel: viewModel)
            SelectedDrawingLotResult(viewModel: viewModel)
            Spacer()
        }
        .onChange(of: phase) { newValue in
            if newValue == .success || newValue == .fail {
                self.viewModel.getPensionEntities()
                self.phase = .notRequested
            }
        }
    }
}

private struct SelectedPensionResult: View {
    
    @ObservedObject var viewModel: PensionWinningCheckViewModel
    
    fileprivate var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("연금복권 회차")
                    .font(.headline)
                
                Spacer()
                
                if viewModel.pensions.count > 0 {
                    Picker("", selection: $viewModel.selectedPension) {
                        ForEach(viewModel.pensions, id: \.self) { pension in
                            Text(verbatim: "\(pension.round)회")
                                .tag(Optional(pension))
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
                if viewModel.selectedPension != nil {
                    resultBoard
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                } else {
                    VStack {
                        Spacer()
                        EmptyPensionDataView()
                        Spacer()
                    }
                    .frame(maxHeight: 150)
                }
            }
            .background(Color.backgroundGray)
            .cornerRadius(10)
        }
    }
    
    var resultBoard: some View {
        VStack(spacing: 4) {
            Text(verbatim: "\(viewModel.selectedPension!.round)회 당첨결과")
                .font(.title)
                .bold()
                .foregroundStyle(Color.primaryColor)
            
            Text("(\(viewModel.selectedPension!.date.toDateStringKor) 추첨)")
                .font(.caption)
                .foregroundStyle(Color.gray2)
            
            VStack(spacing: 0) {
                HStack {
                    Text("1등")
                        .font(.subheadline)
                        .bold()
                    Spacer()
                }
                HStack(spacing: 6) {
                    Spacer()
                    ForEach(Array(viewModel.winNumbers.enumerated()), id:\.offset) { (index, number) in
                        PensionBall(position: index,
                                    number: number ?? -1)
                        if index == 0 {
                            Text("조")
                                .font(.subheadline)
                                .foregroundStyle(Color.primaryColor)
                        }
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .background(Color.pureBackground)
            .cornerRadius(10)
            
            VStack(spacing: 0) {
                HStack {
                    Text("보너스")
                        .font(.subheadline)
                        .bold()
                    Spacer()
                }
                HStack(spacing: 6) {
                    Spacer()
                    Text("각 조")
                        .font(.subheadline)
                        .foregroundStyle(Color.primaryColor)
                    ForEach(Array(viewModel.bonusNumbers.enumerated()), id:\.offset) { (index, number) in
                        PensionBall(position: index+1,
                                    number: number ?? -1)
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .background(Color.pureBackground)
            .cornerRadius(10)
        }
    }
}

private struct SelectedDrawingLotResult: View {
    
    @ObservedObject var viewModel: PensionWinningCheckViewModel
    
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
                                    .foregroundColor(.gray2)
                                    .tag(Optional(result))
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
                    .padding(.horizontal, 20)
                    Divider()
                }
            }
        }
    }
}

private struct CheckRow: View {
    
    @ObservedObject var viewModel: PensionWinningCheckViewModel
    let number: PensionNumbers
    
    private var rank: String {
        if number.numbers.count < 7 || viewModel.winNumbers.count < 7 || viewModel.bonusNumbers.count < 6 {
            return "낙첨"
        }
        
        let numbers = number.numbers
        let winNumbers = viewModel.winNumbers
        if numbers.toPensionNumberString == winNumbers.toPensionNumberString { return "1등🥇" }
        else if Array(numbers[1..<7]).toPensionNumberString == viewModel.bonusNumbers.toPensionNumberString { return "보너스🏅" }
        else if Array(numbers[1..<7]).toPensionNumberString == Array(winNumbers[1..<7]).toPensionNumberString { return "2등🥈" }
        else if Array(numbers[2..<7]).toPensionNumberString == Array(winNumbers[2..<7]).toPensionNumberString { return "3등🥉" }
        else if Array(numbers[3..<7]).toPensionNumberString == Array(winNumbers[3..<7]).toPensionNumberString { return "4등" }
        else if Array(numbers[4..<7]).toPensionNumberString == Array(winNumbers[4..<7]).toPensionNumberString { return "5등" }
        else if Array(numbers[5..<7]).toPensionNumberString == Array(winNumbers[5..<7]).toPensionNumberString { return "6등" }
        else if numbers[6] == winNumbers[6] { return "7등" }
        else { return "낙첨" }
    }
    
    fileprivate init(viewModel: PensionWinningCheckViewModel,
                     number: PensionNumbers) {
        self.viewModel = viewModel
        self.number = number
    }
    
    fileprivate var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(rank)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing: 6) {
                Spacer()
                ForEach(Array(number.numbers.enumerated()), id:\.offset) { (index, number) in
                    if rank == "보너스🏅" {
                        PensionBall(position: index,
                                    number: number,
                                    fixed: index > 0)
                        if index == 0 {
                            Text("조")
                                .font(.subheadline)
                        }
                    } else {
                        PensionBall(position: index,
                                    number: number,
                                    fixed: number == viewModel.winNumbers[index])
                        if index == 0 {
                            Text("조")
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PensionWinningCheckView(viewModel: .init(services: StubService()), 
                            phase: .constant(.notRequested))
}
