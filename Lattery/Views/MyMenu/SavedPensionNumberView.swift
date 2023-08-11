//
//  SavedPensionNumberView.swift
//  Lattery
//
//  Created by dodor on 2023/08/11.
//

import SwiftUI

struct SavedPensionNumberView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var data: PensionData
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date, order: .reverse)
    ]) var pensions: FetchedResults<PensionResult>
    
    var body: some View {
        List {
            ForEach(pensions) { pension in
                SavedPensionNumberRow(pension: pension)
                    .padding(5)
                    .swipeActions {
                        Button(role: .destructive) {
                            data.deletePensionResult(pension, context: moc)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
            
            if pensions.count < 1 {
                Text("저장한 추첨번호가 없습니다.")
                    .foregroundColor(.accentColor)
            }
        }
        .navigationTitle("저장한 추첨번호")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private struct SavedPensionNumberRow: View {
        var pension: PensionResult
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(pension.date?.toDateTimeKor ?? "yy년MM월dd일 HH시mm분") 추첨번호")
                    .foregroundColor(.accentColor)
                    .font(.callout)
                
                HStack {
                    ForEach(Array((pension.numbers1 ?? "").enumerated()), id:\.offset) { (index, char) in
                        PensionBall(number: Int16(String(char)),
                                    unit: index)
                        
                        if index == 0 {
                            Text("조")
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                HStack {
                    ForEach(Array((pension.numbers2 ?? "").enumerated()), id:\.offset) { (index, char) in
                        PensionBall(number: Int16(String(char)),
                                    unit: index)
                        
                        if index == 0 {
                            Text("조")
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                HStack {
                    ForEach(Array((pension.numbers3 ?? "").enumerated()), id:\.offset) { (index, char) in
                        PensionBall(number: Int16(String(char)),
                                    unit: index)
                        
                        if index == 0 {
                            Text("조")
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                HStack {
                    ForEach(Array((pension.numbers4 ?? "").enumerated()), id:\.offset) { (index, char) in
                        PensionBall(number: Int16(String(char)),
                                    unit: index)
                        
                        if index == 0 {
                            Text("조")
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                HStack {
                    ForEach(Array((pension.numbers5 ?? "").enumerated()), id:\.offset) { (index, char) in
                        PensionBall(number: Int16(String(char)),
                                    unit: index)
                        
                        if index == 0 {
                            Text("조")
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

struct SavedPensionNumberView_Previews: PreviewProvider {
    static var previews: some View {
        SavedPensionNumberView()
    }
}
