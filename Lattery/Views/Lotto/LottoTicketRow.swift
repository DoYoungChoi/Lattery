//
//  LottoTicketRow.swift
//  Lattery
//
//  Created by dodor on 2023/07/30.
//

import SwiftUI

struct LottoTicketRow: View {
    @EnvironmentObject var data: LottoData
    var group: LottoGroup
    
    var body: some View {
        HStack {
            Text("\(group.rawValue)")
                .bold()
                .frame(width: 30)
            
            ForEach(data.numberGroups[group] ?? [], id:\.self) { number in
                Spacer()
                Text("\(String(format: "%02d", number))")
                    .frame(width: 40)
            }
        }
    }
}

struct LottoTicketRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ForEach(LottoGroup.allCases) { group in
                LottoTicketRow(group: group)
            }
        }
        .environmentObject(LottoData())
    }
}
