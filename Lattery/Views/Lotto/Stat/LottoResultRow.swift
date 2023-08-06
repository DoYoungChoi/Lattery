//
//  LottoResultRow.swift
//  Lattery
//
//  Created by dodor on 2023/08/03.
//

import SwiftUI

struct LottoResultRow: View {
    var lotto: LottoEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Rectangle()
                    .frame(width: 5)
                    .foregroundColor(.backgroundGray)
                
                Text(verbatim: "\(lotto.round)회")
                    .bold()
                Text("(\(lotto.date?.toDateStringKor ?? "yyyy년 MM월 dd일") 추첨)")
                    .foregroundColor(.customGray)
                    .lineLimit(1)
            }
        }
    }
}

//struct LottoResultRow_Previews: PreviewProvider {
//    static var previews: some View {
//        LottoResultRow()
//    }
//}
