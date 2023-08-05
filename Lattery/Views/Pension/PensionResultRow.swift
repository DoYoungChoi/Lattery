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
            Text(verbatim: "\(pension.round)회")
                .bold()
            HStack {
                PensionBall(number: pension.winClass, unit: 0)
                Text("조")
                ForEach(Array(winNumber.enumerated()), id:\.offset) { (index, char) in
                    PensionBall(number: Int16(String(char)), unit: index+1)
                }
            }
        }
    }
}

//struct PensionResultRow_Previews: PreviewProvider {
//    static var previews: some View {
//        PensionResultRow()
//    }
//}
