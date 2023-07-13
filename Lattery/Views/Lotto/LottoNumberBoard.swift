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
    @State private var selectedNumbers: [Int16] = []
    @State private var isFavorite: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button("취소") {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button("저장") {
                    saveFixedNumber()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.horizontal, 9)
            
            Spacer()
            
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
            .frame(height: 60)
            
            Spacer()
            
            HStack {
                Text("나의 번호로 저장")
                    .font(.title3)
                    .bold()
                Spacer()
                Button {
                    isFavorite.toggle()
                } label: {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.latteYellow)
                        .shadow(color: .latteYellow, radius: isFavorite ? 5 : 0)
                }
            }
            .padding(.horizontal, 9)
            
            Spacer()
            
            LazyVGrid(columns: columnLayout) {
                ForEach(1...45, id: \.self) { number in
                    Button {
                        withAnimation {
                            if selectedNumbers.contains(Int16(number)) {
                                selectedNumbers.removeAll { $0 == number }
                            } else {
                                if selectedNumbers.count < 6 {
                                    selectedNumbers.append(Int16(number))
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
                    saveFixedNumber()
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
            guard let fixed = data.fixedNumbers[group] else { return }
            selectedNumbers = Array(fixed).sorted()
        }
    }
    
    private func saveFixedNumber() {
        let _ = data.setFixedNumbers(selectedNumbers)
    }
}

struct LottoNumberBoard_Previews: PreviewProvider {
    static var previews: some View {
        LottoNumberBoard()
            .environmentObject(LottoData())
    }
}
