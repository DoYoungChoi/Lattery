//
//  PensionTicketRow.swift
//  Lattery
//
//  Created by dodor on 2023/07/31.
//

import SwiftUI

struct PensionTicketRow: View {
    var numbers: [Int16]
    
    var body: some View {
        HStack {
            ForEach(Array(numbers.enumerated()), id:\.offset) { (index, number) in
                Spacer()
                if index == 0 {
                    Text("\(String(number))조")
                        .frame(width: 40)
                } else {
                    Text("\(String(number))")
                        .frame(width: 30)
                }
            }
        }
    }
}

struct PensionTicketRow_Previews: PreviewProvider {
    static var previews: some View {
        PensionTicketRow(numbers: [1, 2, 3, 4, 5, 6, 7])
    }
}
