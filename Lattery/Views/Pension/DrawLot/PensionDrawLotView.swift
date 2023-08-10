//
//  PensionDrawLotView.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import SwiftUI

struct PensionDrawLotView: View {
    @EnvironmentObject var data: PensionData
    @State private var pensionGroup: PensionGroup = .allGroup
    @State private var showNumberBoard: Bool = false
    @State private var isRunning: Bool = false

    var body: some View {
        VStack {
            // MARK: - '모든 조' 또는 '조 선택'
            PensionGroupPicker(selection: $pensionGroup) {
                data.changePensionGroup(to: pensionGroup)
            }
            
            // MARK: - 숫자 조합
            if data.pensionGroup == .allGroup {
                ForEach(0..<5, id:\.self) { index in
                    let group = Int16(index + 1)
                    PensionBallRow(group: [group] + data.numberGroupForAll)
                }
            } else {
                ForEach(Array(data.numberGroupsForEach.enumerated()), id: \.offset) { (index, numbers) in
                    PensionBallRow(group: numbers,
                                   removeAction: data.groupCount > 1 && index == data.groupCount - 1 ? data.removeSelectedNumberGroup : nil)
                }
                
                if data.numberGroupsForEach.count < 5 {
                    addButton
                }
            }
            
            Spacer()
            
            DrawLotButton(isRunning: $isRunning, isEnded: $data.isEnded, action: data.drawLot)
        }
        .padding(.horizontal)
        .navigationTitle("연금720번호 추첨")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                RefreshButton(action: data.reset)
            }
            
            ToolbarItem {
                Button {
                    showNumberBoard.toggle()
                } label: {
                    Image("check_pencil")
                }
            }
        }
        .disabled(isRunning)
        .sheet(isPresented: $showNumberBoard) {
            if #available(iOS 16.0, *) {
                PensionNumberBoard()
                    .presentationDetents(data.pensionGroup == .allGroup ? [.height(480)] : Set(stride(from: 0.8, through: 1.0, by: 0.2).map { PresentationDetent.fraction($0) }))
            } else {
                PensionNumberBoard()
            }
        }
        .onAppear {
            pensionGroup = data.pensionGroup
            data.reset()
        }
    }
    
    private var addButton: some View {
        Button {
            withAnimation { data.addSelectedNumberGroup() } 
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.backgroundGray)
                .overlay {
                    Image(systemName: "plus")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
        }
        .frame(height: 30)
    }
    
    private struct PensionGroupPicker: View {
        @Binding var selection: PensionGroup
        var action: () -> ()
        
        var body: some View {
            HStack {
                ForEach(PensionGroup.allCases) { group in
                    VStack(spacing: 0) {
                        Text(group.id)
                            .padding(.vertical, 3)
                        
                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(.customPink)
                            .opacity(selection == group ? 1 : 0)
                    }
                    .background(.background)
                    .opacity(selection == group ? 1 : 0.3)
                    .onTapGesture {
                        withAnimation {
                            selection = group
                            action()
                        }
                    }
                }
            }
        }
    }
}

struct PensionDrawLotView_Previews: PreviewProvider {
    static var previews: some View {
        PensionDrawLotView()
            .environmentObject(PensionData())
    }
}
