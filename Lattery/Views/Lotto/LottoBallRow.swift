//
//  LottoBallRow.swift
//  Lattery
//
//  Created by dodor on 2023/07/12.
//

import SwiftUI

struct LottoBallRow: View {
    @EnvironmentObject var data: LottoData
    var group: LottoGroup
    @Binding var showNumberBoard: Bool
    
    var body: some View {
        HStack {
            Text(group.rawValue)
                .bold()
                .font(.title3)
                .padding(.horizontal)
            
            if let numbers = data.numbers[group] {
                ForEach(numbers, id:\.self) { number in
                    LottoBall(number: number,
                              isFixed: data.fixedNumbers[group]?.contains(number) ?? false)
                }
            } 
            
            Button {
                data.selectedGroup = group
                showNumberBoard.toggle()
            } label: {
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 20)
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.thinMaterial)
        }
    }
}

struct LottoBallRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ForEach(LottoGroup.allCases) { group in
                LottoBallRow(group: group,
                             showNumberBoard: .constant(true))
            }
        }
        .environmentObject(LottoData())
    }
}
