//
//  PensionCombinationRow.swift
//  Lattery
//
//  Created by dodor on 2023/08/08.
//

import SwiftUI

struct PensionCombinationRow: View {
    var pension: PensionEntity
    var selected: [Int16]
    var includeBonus: Bool
    private var winNumbers: String {
        pension.winNumbers ?? ""
    }
    private var bonusNumbers: String {
        pension.bonusNumbers ?? ""
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Rectangle()
                    .frame(width: 5)
                    .foregroundColor(.backgroundGray)
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(verbatim: "\(pension.round)회")
                            .bold()
                        Text("(\(pension.date?.toDateStringKor ?? "yyyy년 MM월 dd일") 추첨)")
                            .foregroundColor(.accentColor)
                    }
                    
                    HStack {
                        Text("1등")
                        Spacer()
                        PensionBall(number: pension.winClass,
                                    unit: 0,
                                    isSelected: String(selected[0]) == String(pension.winClass))
                        Text("조")
                        ForEach(Array(winNumbers.enumerated()), id:\.offset) { (index, number) in
                            PensionBall(number: Int16(String(number)) ?? -1,
                                        unit: index + 1,
                                        isSelected: String(selected[index+1]) == String(number))
                        }
                    }
                    
                    if includeBonus {
                        HStack {
                            Text("보너스")
                            Spacer()
                            Text("각 조")
                            ForEach(Array(bonusNumbers.enumerated()), id:\.offset) { (index, number) in
                                PensionBall(number: Int16(String(number)) ?? -1,
                                            unit: index + 1,
                                            isSelected: String(selected[index+1]) == String(number))
                            }
                        }
                    }
                }
                .font(.caption)
            }
        }
    }
}
