//
//  PensionWinningCheckView.swift
//  Lattery
//
//  Created by dodor on 12/7/23.
//

import SwiftUI

struct PensionWinningCheckView: View {
    
    @StateObject var viewModel: PensionWinningCheckViewModel
    
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
                                .foregroundColor(.gray2)
                                .tag(pension)
                        }
                    }
                    .pickerStyle(.menu)
                } else {
                    Text("데이터가 없습니다")
                        .font(.subheadline)
                        .foregroundColor(.gray2)
                }
            }
            
            Group {
                if viewModel.selectedPension != nil {
                    resultBoard
                } else {
                    EmptyPensionDataView()
                        .frame(maxHeight: 150)
                }
            }
            .background(Color.backgroundGray)
            .cornerRadius(10)
        }
    }
    
    var resultBoard: some View {
        VStack(spacing: 4) {
            Text(verbatim: "\(viewModel.selectedPension?.round)회 당첨결과")
                .font(.title)
                .bold()
                .foregroundStyle(Color.primaryColor)
            
            Text("(\(viewModel.selectedPension?.date.toDateStringKor ?? "YYYY년 MM월 dd일") 추첨)")
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
                    PensionBall(position: 0,
                                number: Int(viewModel.selectedPension!.group))
                    Text("조")
                        .font(.subheadline)
                    ForEach(Array(viewModel.winNumbers.enumerated()), id:\.offset) { (index, number) in
                        PensionBall(position: index+1,
                                    number: Int(String(number)))
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
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
                    ForEach(Array(viewModel.bonusNumbers.enumerated()), id:\.offset) { (index, number) in
                        PensionBall(position: index+1,
                                    number: Int(String(number)))
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
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
                                    .tag(result)
                            }
                        }
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
                ForEach(viewModel.savedResult, id:\.self) { result in
                    CheckRow(viewModel: viewModel,
                             result: result)
                    Divider()
                }
            }
        }
    }
}

private struct CheckRow: View {
    
    @ObservedObject var viewModel: PensionWinningCheckViewModel
    let result: String
    private var drawingLotNumbers: [Int?] {
        result.split(separator: ",").map { Int($0) }
    }
    private var rankText: String {
        if rank == 1 {
            return "🥇1등🥇"
        } else if rank == 2 {
            return "🥈2등🥈"
        } else if rank == 3 {
            return "🥉3등🥉"
        } else if rank == 8 {
            return "🏅보너스🏅"
        } else if rank < 8 {
            return "\(rank)등"
        } else {
            return "낙첨"
        }
    }
    private var rank: Int {
        guard viewModel.winNumbers.count == 7
                && viewModel.bonusNumbers.count == 6
                && result.count == 7
        else { return 9 }
        
        if viewModel.winNumbers == result { return 1 }
        var index = viewModel.winNumbers.index(viewModel.winNumbers.startIndex, offsetBy: 1)
        if viewModel.winNumbers.suffix(from: index) == result.suffix(from: index) { return 2 }
        if viewModel.bonusNumbers == result.suffix(from: index) { return 8 }
        index = viewModel.winNumbers.index(viewModel.winNumbers.startIndex, offsetBy: 2)
        if viewModel.winNumbers.suffix(from: index) == result.suffix(from: index) { return 3 }
        index = viewModel.winNumbers.index(viewModel.winNumbers.startIndex, offsetBy: 3)
        if viewModel.winNumbers.suffix(from: index) == result.suffix(from: index) { return 4 }
        index = viewModel.winNumbers.index(viewModel.winNumbers.startIndex, offsetBy: 4)
        if viewModel.winNumbers.suffix(from: index) == result.suffix(from: index) { return 5 }
        index = viewModel.winNumbers.index(viewModel.winNumbers.startIndex, offsetBy: 5)
        if viewModel.winNumbers.suffix(from: index) == result.suffix(from: index) { return 6 }
        index = viewModel.winNumbers.index(viewModel.winNumbers.startIndex, offsetBy: 6)
        if viewModel.winNumbers.suffix(from: index) == result.suffix(from: index) { return 7 }
        return 9
    }
    
    fileprivate init(viewModel: PensionWinningCheckViewModel,
                     result: String) {
        self.viewModel = viewModel
        self.result = result
    }
    
    fileprivate var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(rankText)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing: 6) {
                Spacer()
                ForEach(Array(drawingLotNumbers.enumerated()), id:\.offset) { (index, number) in
                    PensionBall(position: index+1,
                                number: number)
                    if index == 0 {
                        Text("조")
                            .font(.subheadline)
                    }
                }
            }
        }
    }
}

#Preview {
    PensionWinningCheckView(viewModel: .init())
}
