//
//  LottoInfoView.swift
//  Lattery
//
//  Created by dodor on 2023/08/07.
//

import SwiftUI

let lottoInfo = [
    LottoInfo(ranking: 1,
              denominator: 8_145_060,
              condition: "6개 번호 일치"),
    LottoInfo(ranking: 2,
              denominator: 1_357_510,
              condition: "5개 번호 일치 + 보너스 번호 일치"),
    LottoInfo(ranking: 3,
              denominator: 35_724,
              condition: "5개 번호 일치"),
    LottoInfo(ranking: 4,
              denominator: 733,
              condition: "4개 번호 일치"),
    LottoInfo(ranking: 5,
              denominator: 45,
              condition: "3개 번호 일치")
]

struct LottoInfo: Identifiable {
    var id: Int { ranking}
    var ranking: Int
    var denominator: Int
    var condition: String
}

struct LottoInfoView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("로또 당첨 정보")
                .font(.title3)
                .bold()
                .padding(.vertical)
            
            Divider()
            LottoInfoRow()
            Divider()
            ForEach(lottoInfo) { info in
                LottoInfoRow(info: info)
                Divider()
            }
        }
    }
    
    private struct LottoInfoRow: View {
        var info: LottoInfo?
        
        var body: some View {
            HStack(spacing: 0) {
                Divider()
                if let info = info {
                    Text("\(info.ranking)등")
                        .frame(width: 70)
                    Divider()
                    Text("1 / \(info.denominator)")
                        .frame(width: 130)
                    Divider()
                    HStack {
                        Spacer()
                        Text(info.condition)
                        Spacer()
                    }
                } else {
                    Text("등위")
                        .foregroundColor(.customGray)
                        .bold()
                        .frame(width: 70)
                    Divider()
                    Text("당첨확률")
                        .foregroundColor(.customGray)
                        .bold()
                        .frame(width: 130)
                    Divider()
                    HStack {
                        Spacer()
                        Text("당첨조건")
                            .foregroundColor(.customGray)
                            .bold()
                        Spacer()
                    }
                }
                Divider()
            }
            .font(.system(size: 16))
        }
    }
}

struct LottoInfoView_Previews: PreviewProvider {
    static var previews: some View {
        LottoInfoView()
    }
}
