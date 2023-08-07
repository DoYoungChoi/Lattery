//
//  LottoStatMenuView.swift
//  Lattery
//
//  Created by dodor on 2023/08/07.
//

import SwiftUI

struct LottoStatMenuView: View {
    @State private var statType: StatType = .count
    private enum StatType: String, Identifiable, CaseIterable {
        case count = "출현 횟수"
        case coappear = "번호 조합"
        case color = "색상 통계"
        var id: String { self.rawValue }
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(StatType.allCases) { type in
                        Button {
                            statType = type
                        } label: {
                            Text(type.id)
                                .foregroundColor(statType == type ? .backgroundGray : .customGray)
                                .padding(10)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(statType == type ? Color.customGray : Color(uiColor: .systemBackground))
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.customGray)
                                }
                        }
                        .opacity(statType == type ? 1 : 0.5)
                    }
                }
                .padding(1)
            }
            
            if statType == .count {
                LottoCountGraphView()
            } else if statType == .coappear {
                
            } else if statType == .color {
                LottoRatioGraphView()
            }
            
            Spacer()
        }
    }
}

struct LottoStatMenuView_Previews: PreviewProvider {
    static var previews: some View {
        LottoStatMenuView()
    }
}
