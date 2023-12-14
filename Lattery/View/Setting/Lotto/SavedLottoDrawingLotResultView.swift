//
//  SavedLottoDrawingLotResultView.swift
//  Lattery
//
//  Created by dodor on 12/14/23.
//

import SwiftUI

struct SavedLottoDrawingLotResultView: View {
    
    @ObservedObject var viewModel: SettingViewModel
    
    var body: some View {
        Group {
            
            if viewModel.lottoDrawingLotResults.count < 1 {
                VStack {
                    Text("저장한 추첨번호가 없습니다.")
                        .foregroundStyle(Color.gray2)
                    Spacer()
                }
            }
            
            List {
                ForEach(viewModel.lottoDrawingLotResults) { lotto in
                    SavedLottoDrawingLotResultRow(drawingLotResult: lotto)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.send(action: .deleteLottoDrawingLotResult(lotto.id))
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .navigationTitle("저장한 로또 추첨번호")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.send(action: .openLottoDrawingLotResult)
        }
    }
}

private struct SavedLottoDrawingLotResultRow: View {
    
    let drawingLotResult: LottoDrawingLotResult
    
    fileprivate init(drawingLotResult: LottoDrawingLotResult) {
        self.drawingLotResult = drawingLotResult
    }
    
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(drawingLotResult.date.toDateTimeKor) 추첨번호")
                .font(.caption)
            
            ForEach(Array(LottoGroup.allCases.enumerated()), id:\.offset) { (index, group) in
                LottoRow(group: group,
                         numbers: drawingLotResult.numbers[index])
            }
        }
    }
}

#Preview {
    SavedLottoDrawingLotResultView(viewModel: .init(services: StubService()))
}
