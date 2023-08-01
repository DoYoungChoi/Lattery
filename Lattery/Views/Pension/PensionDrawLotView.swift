//
//  PensionDrawLotView.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import SwiftUI

struct PensionDrawLotView: View {
    @EnvironmentObject var data: PensionData
    @State private var showNumberBoard: Bool = false
    @State private var isRunning: Bool = false
    
    var body: some View {
        VStack {
            // MARK: - '모든 조' 또는 '조 선택'
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
            
            // MARK: - 숫자 조합
            if data.pensionGroup == .allGroup {
                ForEach(0..<5, id:\.self) { index in
                    let group = Int16(index + 1)
                    PensionBallRow(group: [group] + data.numberGroupForAll)
                }
            } else {
                ForEach(data.numberGroupsForEach, id: \.self) { numbers in
                    PensionBallRow(group: numbers)
                }
                
                if data.numberGroupsForEach.count < 5 {
                    addButton
                }
            }
            
            Spacer()
            DrawLotButton(isRunning: $isRunning, isEnded: $data.isEnded, action: data.drawLot)
        }
        .padding()
        .navigationTitle("⭐️연금720 번호 추첨⭐️")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                RefreshButton(action: data.reset)
            }
            
            ToolbarItem {
                Button {
                    showNumberBoard.toggle()
                } label: {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 20)
                }
            }
        }
        .disabled(isRunning)
        .sheet(isPresented: $showNumberBoard) {
            PensionNumberBoard()
        }
        .onAppear(perform: data.reset)
    }
    
    private var addButton: some View {
        Button {
            withAnimation {
                data.groupCount += 1
                data.reset()
            }
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(.thinMaterial)
                .overlay {
                    Image(systemName: "plus")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
        }
        .frame(height: 30)
    }
}

struct PensionDrawLotView_Previews: PreviewProvider {
    static var previews: some View {
        PensionDrawLotView()
            .environmentObject(PensionData())
    }
}
