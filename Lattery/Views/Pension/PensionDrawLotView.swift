//
//  PensionDrawLotView.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import SwiftUI

struct PensionDrawLotView: View {
    @EnvironmentObject var data: PensionData
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                ForEach(PensionGroup.allCases) { pensionGroup in
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.latteIvory)
                        .frame(height: 40, alignment: .center)
                        .overlay {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.latteBrown)
                                    .opacity(data.pensionGroup == pensionGroup ? 1 : 0)
                                Text(pensionGroup.rawValue)
                            }
                        }
                        .opacity(data.pensionGroup == pensionGroup ? 1 : 0.3)
                        .onTapGesture {
                            withAnimation {
                                data.pensionGroup = pensionGroup
                                data.reset()
                            }
                        }
                }
            }
            
            ForEach(data.sets, id:\.self) { numbers in
                HStack {
                    ForEach(Array(numbers.enumerated()), id:\.offset) { (index, number) in
                        PensionBall(number: number, unit: index)
                        if index == 0 {
                            Text("조")
                        }
                    }
                }
            }
            
            Spacer()
            DrawLotButton(showPawPicker: $isEditing) {
                print("버튼 눌리는 중")
            }
        }
        .padding()
        .navigationTitle("⭐️연금720 번호 추첨⭐️")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem {
                RefreshButton(action: data.reset)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation { isEditing.toggle() }
                } label: {
                    Label("발바닥", systemImage: isEditing ? "pawprint" : "pawprint.fill")
                }
            }
        }
        .onAppear(perform: data.reset)
    }
}

struct PensionDrawLotView_Previews: PreviewProvider {
    static var previews: some View {
        PensionDrawLotView()
            .environmentObject(PensionData())
    }
}
