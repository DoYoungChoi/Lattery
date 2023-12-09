//
//  SavedPensionNumberView.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import SwiftUI

struct SavedPensionNumberView: View {
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        List {
//            ForEach(pensions) { pension in
//                SavedPensionNumberRow(pension: pension)
//                    .padding(5)
//                    .swipeActions {
//                        Button(role: .destructive) {
//                            data.deletePensionResult(pension, context: moc)
//                        } label: {
//                            Label("Delete", systemImage: "trash")
//                        }
//                    }
//            }
//            
//            if pensions.count < 1 {
//                Text("저장한 추첨번호가 없습니다.")
//                    .foregroundColor(.accentColor)
//            }
        }
        .navigationTitle("저장한 추첨번호")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private struct SavedPensionNumberRow: View {
        var pension: PensionResult
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(pension.date.toDateTimeKor) 추첨번호")
                    .foregroundColor(.accentColor)
                    .font(.callout)
                
                HStack {
//                    ForEach(Array((pension.numbers1 ?? "").enumerated()), id:\.offset) { (index, char) in
//                        PensionBall1(number: Int16(String(char)),
//                                    unit: index)
//                        
//                        if index == 0 {
//                            Text("조")
//                        }
//                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

#Preview {
    SavedPensionNumberView()
}
