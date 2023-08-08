//
//  LottoCombinationRow.swift
//  Lattery
//
//  Created by dodor on 2023/08/07.
//

import SwiftUI

struct LottoCombinationRow: View {
    var lotto: LottoEntity
    var selected: Set<Int16>
    var includeBonus: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Rectangle()
                    .frame(width: 5)
                    .foregroundColor(.backgroundGray)
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(verbatim: "\(lotto.round)회")
                            .bold()
                        Text("(\(lotto.date?.toDateStringKor ?? "yyyy년 MM월 dd일") 추첨)")
                            .foregroundColor(.accentColor)
                    }
                    .font(.caption)
                    
                    HStack {
                        LottoBall(number: lotto.no1, isSelected: selected.contains(lotto.no1))
                        LottoBall(number: lotto.no2, isSelected: selected.contains(lotto.no2))
                        LottoBall(number: lotto.no3, isSelected: selected.contains(lotto.no3))
                        LottoBall(number: lotto.no4, isSelected: selected.contains(lotto.no4))
                        LottoBall(number: lotto.no5, isSelected: selected.contains(lotto.no5))
                        LottoBall(number: lotto.no6, isSelected: selected.contains(lotto.no6))
                        if includeBonus {
                            Image(systemName: "plus")
                            LottoBall(number: lotto.noBonus, isSelected: selected.contains(lotto.noBonus))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }
}
