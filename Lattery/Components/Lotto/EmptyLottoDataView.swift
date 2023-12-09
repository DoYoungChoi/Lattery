//
//  EmptyLottoDataView.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct EmptyLottoDataView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("로또 데이터가 없습니다.\n새로고침 버튼을 눌러 데이터를 가져오세요.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray2)
                    .padding(.vertical, 16)
                Spacer()
            }
            
            Spacer()
        }
    }
}

#Preview {
    EmptyLottoDataView()
}
