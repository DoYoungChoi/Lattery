//
//  PensionNumberBoard.swift
//  Lattery
//
//  Created by dodor on 2023/07/31.
//

import SwiftUI

struct PensionNumberBoard: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var data: PensionData
    var forStat: Bool = false
    let columnLayout = Array(repeating: GridItem(), count: 3)
    @State private var selectedNumbers: [[Int16]] = [Array(repeating: -1, count: 7)]
    @State private var selectedIndex: Int = 0
    private var repeatCount: Int {
        data.pensionGroup == .allGroup || forStat ? 1 : data.groupCount
    }
    let colorSet: [Color] = [.customGray, .customRed, .customOrange, .customYellow,
                             .customLightBlue, .customPurple, .customDarkGray]
    
    var body: some View {
        VStack {
            // MARK: - 상단 버튼
            HStack {
                Button("취소") {
                    customInit()
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button("저장") {
                    save()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.horizontal, 9)
            
            Spacer()
            
            // MARK: - 고른 번호 보는 곳
            ForEach(Array(selectedNumbers.enumerated()), id:\.offset) { (i, numbers) in
                HStack {
                    ForEach(Array(numbers.enumerated()), id:\.offset) { (j, number) in
                        let index = i * 10 + j
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                .foregroundColor(selectedIndex == index ? colorSet[j] : .customGray)
                            Text("\(number != -1 ? String(number) : "")\(j == 0 ? "\(data.pensionGroup == .allGroup && !forStat ? "*" : "")조" : "")")
                        }
                        .background(.background)
                        .opacity(selectedIndex == index ? 1 : 0.5)
                        .onTapGesture {
                            if data.pensionGroup == .allGroup && !forStat && j == 0 { return }
                            selectedIndex = index
                        }
                    }
                    
                    if repeatCount > 1 && selectedNumbers.count > 1 {
                        Button {
                            withAnimation { removeRow(at: i) }
                        } label: {
                            Image(systemName: "minus")
                        }
                    }
                }
                .frame(height: 45)
            }
            
            if repeatCount > 1 && selectedNumbers.count < repeatCount {
                Button {
                    withAnimation { addRow() }
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
            
            Spacer()
            
            // MARK: - 번호판
            LazyVGrid(columns: columnLayout) {
                ForEach([1,2,3,4,5,6,7,8,9,-2,0,-1], id:\.self) { number in
                    let col = selectedIndex % 10
                    
                    if number > -2 {
                        Button {
                            let row = selectedIndex / 10
                            selectedNumbers[row][col] = Int16(number)
                            
                            if row < selectedNumbers.count && col != 6 {
                                selectedIndex += 1
                            } else if row < selectedNumbers.count-1 && col == 6 {
                                selectedIndex = (row + 1) * 10
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.customPink)
                                
                                if number < 0 {
                                    Image(systemName: "delete.left")
                                        .font(.title2)
                                        .foregroundColor(.customPink)
                                } else {
                                    Text("\(number)")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.customPink)
                                }
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.customPink)
                                    .opacity(0.1)
                            }
                            .opacity(col == 0 && (number > 5 || number == 0) ? 0.5 : 1)
                        }
                        .frame(width: 80, height: 80)
                        .disabled(col == 0 && (number > 5 || number == 0))
                    } else {
                        Spacer()
                    }
                }
            }
            .frame(width: 260, height: 340)
            
            // MARK: - 저장, 초기화 버튼
            HStack {
                Button {
                    customInit()
                } label: {
                    Text("초기화")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.customPink)
                        }
                }
                
                Button {
                    save()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("저장")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.customPink)
                        }
                }
            }
        }
        .padding()
        .onAppear {
            customInit()
            getOriginSelectedNumbers()
        }
    }
    
    private func customInit() {
        selectedNumbers = [Array(repeating: -1, count: 7)]
        selectedIndex = data.pensionGroup == .allGroup && !forStat ? 1 : 0
    }
    
    private func getOriginSelectedNumbers() {
        if forStat {
            selectedNumbers = [data.numberCombination]
        } else {
            if data.pensionGroup == .allGroup && data.selectedNumbersForAll.count > 0 {
                selectedNumbers = [[-1] + data.selectedNumbersForAll]
            } else if data.pensionGroup == .eachGroup && data.selectedNumbersForEach.count > 0 {
                selectedNumbers = data.selectedNumbersForEach
            }
        }
    }
    
    private func addRow() {
        selectedNumbers += [Array(repeating: -1, count: 7)]
    }
    
    private func removeRow(at row: Int) {
        guard row < selectedNumbers.count else { return }
        selectedNumbers.remove(at: row)
    }
    
    private func save() {
        if forStat {
            data.numberCombination = selectedNumbers[0]
        } else {
            data.addSelectedNumbers(selectedNumbers)
        }
    }
}

struct PensionNumberBoard_Previews: PreviewProvider {
    static var previews: some View {
        PensionNumberBoard()
            .environmentObject(PensionData())
    }
}
