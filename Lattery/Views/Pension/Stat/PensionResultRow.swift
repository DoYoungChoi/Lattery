//
//  PensionResultRow.swift
//  Lattery
//
//  Created by dodor on 2023/08/03.
//

import SwiftUI

struct PensionResultRow: View {
    var pension: PensionEntity
    private var winNumber: String {
        pension.winNumbers ?? ""
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Rectangle()
                    .frame(width: 5)
                    .foregroundColor(.backgroundGray)
                
                Text(verbatim: "\(pension.round)회")
                    .bold()
                Text("(\(pension.date?.toDateStringKor ?? "yyyy년 MM월 dd일") 추첨)")
                    .foregroundColor(.customGray)
                    .lineLimit(1)
            }
        }
    }
}

//struct PensionResultRow_Previews: PreviewProvider {
//    static var previews: some View {
//        PensionResultRow()
//    }
//}