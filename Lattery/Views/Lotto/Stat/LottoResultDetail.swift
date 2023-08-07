//
//  LottoResultDetail.swift
//  Lattery
//
//  Created by dodor on 2023/07/09.
//

import SwiftUI

struct LottoResultDetail: View {
    var lotto: LottoEntity
    
    var body: some View {
        VStack {
            LottoResultBoard(lotto: lotto)
            Spacer()
            LottoInfoView()
            Spacer()
        }
        .padding(.horizontal)
    }
}

//struct LottoResultDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        LottoResultDetail(lotto: LottoEntity(context: M))
//    }
//}
