//
//  LottoNumberBoard.swift
//  Lattery
//
//  Created by dodor on 2023/07/12.
//

import SwiftUI

struct LottoNumberBoard: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var data: LottoData
    var forStat: Bool = false
    var forFavorite: Bool = false
    let columnLayout = Array(repeating: GridItem(), count: 6)
    @State private var selectedNumbers: Set<Int16> = []
    private var isFavorite: Bool {
        data.favorites.contains(selectedNumbers)
    }
    
    var body: some View {
        VStack {
            // MARK: - 상단 버튼
            HStack {
                Button("취소") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button("저장") {
                    save()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            Spacer()
            
            // MARK: - 고른 번호 보는 곳 + 즐겨찾기 등록/취소
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundColor(.customGray)
                    
                    HStack {
                        ForEach(selectedNumbers.sorted(), id: \.self) { number in
                            LottoBall(number: number)
                        }
                    }
                }
                .frame(height: 43)
                
                if !forFavorite {
                    Button {
                        if selectedNumbers.count < 1 { return }
                        if isFavorite {
                            data.deleteFavorites(selectedNumbers)
                        } else {
                            data.addFavorites(selectedNumbers)
                        }
                    } label: {
                        Image(isFavorite ? "heart_fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .shadow(color: .customRed, radius: isFavorite ? 5 : 0)
                    }
                }
            }
            
            Spacer()
            
            if !forFavorite {
                // MARK: - 나의 즐겨찾기 번호
                VStack(alignment: .leading, spacing: 0) {
                    Text("나의 즐겨찾기 번호")
                        .padding(.bottom, 3)
                    LottoFavorites(selectedNumbers: $selectedNumbers)
                }
                
                Spacer()
            }
            
            // MARK: - 번호판
            LazyVGrid(columns: columnLayout) {
                ForEach(1...45, id: \.self) { number in
                    Button {
                        withAnimation {
                            if selectedNumbers.contains(Int16(number)) {
                                selectedNumbers.remove(Int16(number))
                            } else {
                                if selectedNumbers.count < 6 {
                                    selectedNumbers.insert(Int16(number))
                                }
                            }
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(selectedNumbers.contains(Int16(number)) ? Color.customPink : Color.clear)
                            .aspectRatio(1, contentMode: .fit)
                            .overlay {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.customPink)
                                        .aspectRatio(1, contentMode: .fit)
                                    Text("\(number)")
                                        .font(.title3)
                                        .foregroundColor(selectedNumbers.contains(Int16(number)) ? .white : .customPink)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Spacer()
            
            // MARK: - 저장, 초기화 버튼
            HStack {
                Button {
                    selectedNumbers = []
                } label: {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.customPink)
                        .frame(minHeight: 30, maxHeight: 50)
                        .overlay {
                            Text("초기화")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                }
                
                Button {
                    save()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.customPink)
                        .frame(minHeight: 30, maxHeight: 50)
                        .overlay {
                            Text("저장")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            if forStat {
                selectedNumbers = data.numberCombination
            } else if forFavorite {
                selectedNumbers = []
            } else {
                guard let group = data.selectedGroup else { return }
                guard let selected = data.selectedNumbers[group] else { return }
                selectedNumbers = Set(selected.sorted())
            }
        }
    }
    
    private func save() {
        if forStat {
            data.numberCombination = selectedNumbers
        } else if forFavorite {
            data.addFavorites(selectedNumbers)
        } else {
            data.addSelectedNumbers(selectedNumbers)
        }
    }
}

struct LottoNumberBoard_Previews: PreviewProvider {
    static var previews: some View {
        LottoNumberBoard()
            .environmentObject(LottoData())
    }
}
