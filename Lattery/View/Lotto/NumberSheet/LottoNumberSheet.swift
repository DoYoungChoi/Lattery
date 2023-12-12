//
//  LottoNumberSheet.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import SwiftUI

struct LottoNumberSheet: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: LottoNumberSheetViewModel
    @Binding var fixedNumbers: LottoNumbers?
    
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
            HStack(spacing: 16) {
                SelectedNumbers(viewModel: viewModel)
                
                Button {
                    viewModel.send(action: .toggleFavorite)
                } label: {
                    HeartIcon(checked: viewModel.isContainedFavorites)
                }
            }
            
            MyFavoriteNumbersView(viewModel: viewModel)
            
            LottoNumberBoard(viewModel: viewModel)
            
            HStack(spacing: 8) {
                Button("초기화") {
                    viewModel.send(action: .reset)
                }
                
                Button("저장") {
                    save()
                }
            }
            .buttonStyle(CustomButtonStyle())
        }
        .padding(.horizontal, 20)
        .onAppear {
            viewModel.selected = Set(fixedNumbers?.fixedNumbers ?? [])
        }
    }
    
    private func save() {
        fixedNumbers = LottoNumbers(fixedNumbers: Array(self.viewModel.selected))
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - 선택한 번호
private struct SelectedNumbers: View {
    
    @ObservedObject private var viewModel: LottoNumberSheetViewModel
    
    fileprivate init(viewModel: LottoNumberSheetViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(.gray1)
            
            HStack {
                ForEach(viewModel.selected.sorted(), id: \.self) { number in
                    LottoBall(number: number)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
    }
}

// MARK: - 나의 즐겨찾기 번호
private struct MyFavoriteNumbersView: View {
    
    @ObservedObject private var viewModel: LottoNumberSheetViewModel
    
    fileprivate init(viewModel: LottoNumberSheetViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("나의 즐겨찾기 번호")
                .font(.subheadline)
                .bold()
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.backgroundGray)
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 8) {
                        ForEach(viewModel.favorites, id:\.numbers) { favorite in
                            MyFavoriteNumberItem(favorite: favorite.numbers ?? "",
                                                 isSelected: favorite.numbers == Array(viewModel.selected).toLottoNumberString)
                            .onTapGesture {
                                if favorite.numbers == Array(viewModel.selected).toLottoNumberString {
                                    viewModel.send(action: .tapFavoriteNumber(nil))
                                } else {
                                    viewModel.send(action: .tapFavoriteNumber(favorite))
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 55)
        }
    }
}

private struct MyFavoriteNumberItem: View {
    
    var favorite: String
    var isSelected: Bool
    
    fileprivate var body: some View {
        HStack(spacing: 8) {
            ForEach(favorite.toLottoNumbers, id:\.self) { number in
                LottoBall(number: number)
            }
        }
        .padding(8)
        .background(Color.pureBackground)
        .overlay {
            if isSelected {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.accentColor, lineWidth: 3)
            }
        }
        .cornerRadius(10)
    }
}

// MARK: - 번호판
private struct LottoNumberBoard: View {
    @ObservedObject private var viewModel: LottoNumberSheetViewModel
    
    fileprivate init(viewModel: LottoNumberSheetViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<8, id:\.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<6, id:\.self) { col in
                        let number = row * 6 + col + 1
                        if number < 46 {
                            Button {
                                viewModel.send(action: .tapNumber(number))
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(viewModel.isSelected(number) ? Color.accentColor : Color.clear)
                                    
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.accentColor)
                                    
                                    Text("\(number)")
                                        .font(.system(size: 18))
                                        .foregroundColor(viewModel.isSelected(number) ? .white : .accentColor)
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

//#Preview {
//    LottoNumberSheet(fixedNumbers: .constant([1,2,3]))
//}
