//
//  FavoriteLottoNumberSheet.swift
//  Lattery
//
//  Created by dodor on 12/14/23.
//

import SwiftUI

struct FavoriteLottoNumberSheet: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selected: [Int] = []
    var action: ([Int]) -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button("취소") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button("저장") {
                    save()
                }
            }
            .padding(.vertical, 20)
            
            Spacer()
            
            // 선택한 번호
            SelectedNumbers(selectedNumbers: $selected)
            
            Spacer()
            
            LottoNumberBoard(selectedNumbers: $selected)
            
            HStack(spacing: 8) {
                Button("초기화") {
                    selected = []
                }
                
                Button("저장") {
                    save()
                }
            }
            .buttonStyle(CustomButtonStyle())
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
    
    private func save() {
        if !selected.isEmpty {
            action(selected.sorted())
        }
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - 선택한 번호
private struct SelectedNumbers: View {
    
    @Binding var selectedNumbers: [Int]
    
    fileprivate var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(.gray1)
            
            HStack {
                ForEach(selectedNumbers.sorted(), id: \.self) { number in
                    LottoBall(number: number)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
    }
}

// MARK: - 번호판
private struct LottoNumberBoard: View {
    
    @Binding var selectedNumbers: [Int]
    
    fileprivate var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<8, id:\.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<6, id:\.self) { col in
                        let number = row * 6 + col + 1
                        if number < 46 {
                            Button {
                                if selectedNumbers.contains(number) {
                                    selectedNumbers.removeAll(where: { $0 == number })
                                } else {
                                    selectedNumbers.append(number)
                                }
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(selectedNumbers.contains(number) ? Color.accentColor : Color.clear)
                                    
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.accentColor)
                                    
                                    Text("\(number)")
                                        .font(.system(size: 18))
                                        .foregroundColor(selectedNumbers.contains(number) ? .white : .accentColor)
                                        .padding(10)
                                }
                            }
                            .buttonStyle(.plain)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.clear)
                        }
                    }
                }
            }
        }
    }
}
