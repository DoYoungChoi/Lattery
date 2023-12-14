//
//  SavedPensionDrawingLotResultView.swift
//  Lattery
//
//  Created by dodor on 12/14/23.
//

import SwiftUI

struct SavedPensionDrawingLotResultView: View {
    
    @ObservedObject var viewModel: SettingViewModel
    
    var body: some View {
        Group {
            
            if viewModel.pensionDrawingLotResults.count < 1 {
                VStack {
                    Text("저장한 추첨번호가 없습니다.")
                        .foregroundStyle(Color.gray2)
                    Spacer()
                }
            }
            
            List {
                ForEach(viewModel.pensionDrawingLotResults, id:\.id) { pension in
                    SavedPensionDrawingLotResultRow(drawingLotResult: pension)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.send(action: .deletePensionDrawingLotResult(pension.id))
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .navigationTitle("저장한 연금복권 추첨번호")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.send(action: .openPensionDrawingLotResult)
        }
    }
}

private struct SavedPensionDrawingLotResultRow: View {
    
    let drawingLotResult: PensionDrawingLotResult
    
    fileprivate init(drawingLotResult: PensionDrawingLotResult) {
        self.drawingLotResult = drawingLotResult
    }
    
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(drawingLotResult.date.toDateTimeKor) 추첨번호")
                .font(.caption)

            ForEach(drawingLotResult.numbers, id:\.self) { numbers in
                PensionRow(numbers: numbers)
            }
        }
    }
}

#Preview {
    SavedPensionDrawingLotResultView(viewModel: .init(services: StubService()))
}
