//
//  PensionNumberSheet.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct PensionNumberSheet: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var fixedNumbers: [Int?]
    
    @State private var selected: [Int?] = Array(repeating: nil, count: 7)
    @State var index: Int = 0
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button("취소") { presentationMode.wrappedValue.dismiss() }
                Spacer()
                Button("저장") {
                    save()
                }
            }
            .padding(.vertical, 20)
            
            Spacer()
            
            // 선택한 번호
            SelectedNumbers(selected: $selected,
                            index: $index)
            
            Spacer()
            
            PensionNumberBoard(selected: $selected,
                               index: $index)
            
            HStack(spacing: 8) {
                Button("초기화") { reset() }
                Button("저장") { save() }
            }
            .buttonStyle(CustomButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
        .onAppear { onAppear() }
    }
}

extension PensionNumberSheet {
    private func onAppear() {
        if fixedNumbers.count == 7 {
            selected = fixedNumbers
        } else if fixedNumbers.count < 7 {
            selected = fixedNumbers + Array(repeating: nil, count: 7-fixedNumbers.count)
        } else {
            selected = Array(fixedNumbers[0..<7])
        }
        
        if let idx = selected.firstIndex(of: nil) {
            index = idx
        }
    }
    
    private func reset() {
        selected = Array(repeating: nil, count: 7)
        index = 0
    }
    
    private func save() {
        fixedNumbers = selected
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - 선택한 번호
private struct SelectedNumbers: View {
    
    @Binding var selected: [Int?]
    @Binding var index: Int
    
    fileprivate var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<7, id:\.self) { index in
                SelectedNumberItem(number: selected[index],
                                   color: index == self.index
                                            ? index.pensionColor
                                            : .gray1)
                .onTapGesture {
                    self.index = index
                }
                
                if index == 0 {
                    Text("조")
                        .font(.subheadline)
                        .foregroundStyle(Color.primaryColor)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
    }
}

private struct SelectedNumberItem: View {
    
    let number: Int?
    let color: Color
    
    fileprivate init(number: Int?, color: Color) {
        self.number = number
        self.color = color
    }
    
    fileprivate var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(color, lineWidth: 3)
            
            if let number {
                Text("\(number)")
                    .font(.headline)
                    .foregroundStyle(color)
            }
        }
        .frame(maxHeight: 70)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - 번호판
private struct PensionNumberBoard: View {
    
    @Binding var selected: [Int?]
    @Binding var index: Int
    private let columnLayout = Array(repeating: GridItem(), count: 3)
    
    fileprivate var body: some View {
        LazyVGrid(columns: columnLayout) {
            ForEach([1,2,3,4,5,6,7,8,9,-2,0,-1], id:\.self) { number in
                Group {
                    if number == -1 {
                        Button {
                            selected[index] = nil
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.accentColor, lineWidth: 2)
                                Image(systemName: "delete.left")
                                    .font(.headline)
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                    } else if number > -1 {
                        Button {
                            selected[index] = number
                            if index < 6 { index += 1 }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.accentColor, lineWidth: 2)
                                Text("\(number)")
                                    .font(.headline)
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                        .disabled(index == 0 && ((number > 5 && number < 10) || number == 0))
                    } else {
                        Spacer()
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .frame(maxHeight: 70)
            }
            
        }
        .frame(width: 220)
    }
}

#Preview {
    PensionNumberSheet(fixedNumbers: .constant([]))
}
