//
//  PensionStatMenuView.swift
//  Lattery
//
//  Created by dodor on 2023/08/08.
//

import SwiftUI

struct PensionStatMenuView: View {
    @State private var statType: StatType = .count
    private enum StatType: String, Identifiable, CaseIterable {
        case count = "출현 횟수"
        case combination = "번호 조합"
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
                                .foregroundColor(statType == type ? Color(uiColor: .systemBackground) : .customGray)
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
                PensionRatioGraphView()
            } else if statType == .combination {
                PensionCombinationView()
            }
            
            Spacer()
        }
    }
}

struct PensionStatMenuView_Previews: PreviewProvider {
    static var previews: some View {
        PensionStatMenuView()
    }
}
