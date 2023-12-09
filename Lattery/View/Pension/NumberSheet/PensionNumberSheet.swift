//
//  PensionNumberSheet.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct PensionNumberSheet: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: PensionNumberSheetViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button("취소") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button("저장") {
                    viewModel.send(action: .save)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.vertical, 20)
            
            Spacer()
            
            // 선택한 번호
            SelectedNumbers(viewModel: viewModel)
            
//            PensionNumberBoard(viewModel: viewModel)
            
            HStack(spacing: 8) {
                Button("초기화") {
                    viewModel.send(action: .reset)
                }
                
                Button("저장") {
                    viewModel.send(action: .save)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .buttonStyle(CustomButtonStyle())
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - 선택한 번호
private struct SelectedNumbers: View {
    @ObservedObject private var viewModel: PensionNumberSheetViewModel
    
    fileprivate init(viewModel: PensionNumberSheetViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(.gray1)
            
            HStack {

            }
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
    }
}

// MARK: - 번호판
private struct PensionNumberBoard: View {
    
    @ObservedObject private var viewModel: PensionNumberSheetViewModel
    private let columnLayout = Array(repeating: GridItem(), count: 3)
    
    fileprivate init(viewModel: PensionNumberSheetViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        LazyVGrid(columns: columnLayout) {
            ForEach([1,2,3,4,5,6,7,8,9,-2,0,-1], id:\.self) { number in
//                let col = selectedIndex % 10
                
                Group {
                    if number == -1 {
                        Button {
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.accentColor)
                                    .opacity(0.1)
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.accentColor)
                                Image(systemName: "delete.left")
                                    .font(.headline)
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                    } else if number > -2 {
                        Button {
//                            let row = selectedIndex / 10
//                            selectedNumbers[row][col] = Int16(number)
//
//                            if row < selectedNumbers.count && col != 6 {
//                                selectedIndex += 1
//                            } else if row < selectedNumbers.count-1 && col == 6 {
//                                selectedIndex = (row + 1) * 10
//                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.accentColor)
                                    .opacity(0.1)
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.accentColor)
                                Text("\(number)")
                                    .font(.headline)
                                    .foregroundStyle(Color.accentColor)
                            }
//                            .opacity(col == 0 && (number > 5 || number == 0) ? 0.5 : 1)
                        }
//                        .disabled(col == 0 && (number > 5 || number == 0))
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
    PensionNumberSheet(viewModel: .init())
}
