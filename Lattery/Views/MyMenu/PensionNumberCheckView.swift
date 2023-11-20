//
//  PensionNumberCheckView.swift
//  Lattery
//
//  Created by dodor on 2023/08/10.
//

import SwiftUI

struct PensionNumberCheckView: View {
    var entity: PensionResult
    var winInfo: PensionEntity?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Divider()
                ForEach([entity.numbers1, entity.numbers2, entity.numbers3, entity.numbers4, entity.numbers5], id:\.self) { numberString in
                    if let numberString = numberString {
                        PensionNumberCheckRow(numberString: numberString ?? "",
                                              winNumbers: String(winInfo?.winClass ?? 9) + (winInfo?.winNumbers ?? ""),
                                              bonusNumbers: winInfo?.bonusNumbers ?? "")
                        .padding(.vertical, 10)
                        Divider()
                    }
                }
            }
        }
    }
}
