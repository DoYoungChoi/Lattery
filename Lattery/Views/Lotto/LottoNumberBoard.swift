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
                    data.addSelectedNumbers(selectedNumbers)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.horizontal, 9)
            
            Spacer()
            
            // MARK: - 고른 번호 보는 곳 + 즐겨찾기 등록/취소
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundColor(.latteGray)
                    
                    HStack {
                        ForEach(selectedNumbers.sorted(), id: \.self) { number in
                            LottoBall(number: number)
                        }
                    }
                }
                .frame(height: 43)
                
                Button {
                    if isFavorite {
                        data.deleteFavorites(selectedNumbers)
                    } else {
                        data.addFavorites(selectedNumbers)
                    }
                } label: {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.latteYellow)
                        .shadow(color: .latteYellow, radius: isFavorite ? 5 : 0)
                }
            }
            
            Spacer()
            
            // MARK: - 나의 즐겨찾기 번호
            VStack(alignment: .leading, spacing: 0) {
                Text("나의 즐겨찾기 번호")
                    .padding(.bottom, 5)
                LottoFavorites(selectedNumbers: $selectedNumbers)
            }
            
            Spacer()
            
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
                        Text("\(number)")
                            .font(.system(size: 20))
                            .foregroundColor(selectedNumbers.contains(Int16(number)) ? .white : .lattePink)
                            .frame(width: 50, height: 50, alignment: .center)
                            .background {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(selectedNumbers.contains(Int16(number)) ? Color.lattePink : Color.clear)
                            }
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.lattePink)
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
                    Text("초기화")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.lattePink)
                        }
                }
                
                Button {
                    data.addSelectedNumbers(selectedNumbers)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("저장")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.lattePink)
                        }
                }
            }
        }
        .padding()
        .onAppear {
            guard let group = data.selectedGroup else { return }
            guard let selected = data.selectedNumbers[group] else { return }
            selectedNumbers = Set(selected.sorted())
        }
    }
}

struct LottoNumberBoard_Previews: PreviewProvider {
    static var previews: some View {
        LottoNumberBoard()
            .environmentObject(LottoData())
    }
}
