//
//  LottoFavorites.swift
//  Lattery
//
//  Created by dodor on 2023/07/27.
//

import SwiftUI

struct LottoFavorites: View {
    @EnvironmentObject var data: LottoData
    @Binding var selectedNumbers: Set<Int16>
    private let backgroundColor = Color(uiColor: .systemBackground)
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(data.favorites, id:\.self) { numbers in
                    HStack {
                        ForEach(numbers.sorted(by: <), id:\.self) { number in
                            LottoBall(number: number)
                        }
                    }
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(backgroundColor)
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(numbers == selectedNumbers ? Color.customPink : backgroundColor)
                    }
                    .padding([.leading, .vertical], 1)
                    .onTapGesture {
                        if numbers == selectedNumbers {
                            selectedNumbers = []
                        } else {
                            selectedNumbers = numbers
                        }
                    }
                }
            }
        }
        .padding(4)
        .frame(height: 50)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.backgroundGray)
        }
    }
}

struct LottoFavorites_Previews: PreviewProvider {
    static var previews: some View {
        LottoFavorites(selectedNumbers: .constant([]))
            .environmentObject(LottoData())
    }
}
