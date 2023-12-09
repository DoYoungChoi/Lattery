//
//  LottoResultView.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct LottoResultView: View {
    
    var lotto: LottoEntity
    
    var body: some View {
        VStack(spacing: 8) {
            LottoWinResult(lotto: lotto)
            LottoWinInfoTable()
        }
    }
}
//
private struct LottoWinResult: View {
    
    let lotto: LottoEntity
    
    fileprivate init(lotto: LottoEntity) {
        self.lotto = lotto
    }
    
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // TITLE
            Text(verbatim: "\(lotto.round)회 당첨결과")
                .font(.largeTitle)
            
            // 추첨일
            Text("\(lotto.date.toDateStringKor) 추첨")
                .font(.headline)
                .foregroundStyle(Color.gray2)
            
            // LOTTO BALL ROW
            HStack(spacing: 8) {
                ForEach(lotto.numbers, id:\.self) { number in
                    LottoBall(number: number)
                }
                Image(systemName: "plus")
                    .foregroundColor(.gray3)
                LottoBall(number: Int(lotto.bonus))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .center)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundGray)
            }
            
            // 당첨자수
            HStack {
                Image(systemName: "person.2")
                Text("당첨자수")
                Spacer()
                Text("\(lotto.winnerCount)명")
            }
            .foregroundColor(.primaryColor)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundGray)
            }
            
            // 1등 상금
            HStack {
                Image(systemName: "banknote")
                Text("1등 상금")
                Spacer()
                Text("\(lotto.winnings)원")
            }
            .foregroundColor(.primaryColor)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundGray)
            }
            
            // 총 판매금액
            HStack(spacing: 8) {
                Text("총 판매금액: ")
                Text("\(lotto.totalSalePrice)원")
                    .bold()
            }
            .foregroundColor(.primaryColor)
            .font(.caption)
            .foregroundColor(.gray2)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

private struct LottoWinInfoTable: View {
    private let lottoInfo = [
        InfoObject(ranking: 1,
                   denominator: 8_145_060,
                   condition: "6개 번호 일치"),
        InfoObject(ranking: 2,
                   denominator: 1_357_510,
                   condition: "5개 번호 일치 + 보너스 번호 일치"),
        InfoObject(ranking: 3,
                   denominator: 35_724,
                   condition: "5개 번호 일치"),
        InfoObject(ranking: 4,
                   denominator: 733,
                   condition: "4개 번호 일치"),
        InfoObject(ranking: 5,
                   denominator: 45,
                   condition: "3개 번호 일치")
    ]
    
    private struct InfoObject: Identifiable {
        var id: Int { ranking }
        var ranking: Int
        var denominator: Int
        var condition: String
    }
    
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("로또 당첨 정보")
                .font(.headline)
            
            Divider()
            LottoWinInfoRow()
            ForEach(lottoInfo) { info in
                LottoWinInfoRow(info: info)
                Divider()
            }
        }
        .foregroundStyle(Color.primaryColor)
    }
    
    private struct LottoWinInfoRow: View {
        var info: InfoObject?
        
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
                        .foregroundColor(.gray2)
                        .bold()
                        .frame(width: 70)
                    Divider()
                    Text("당첨확률")
                        .foregroundColor(.gray2)
                        .bold()
                        .frame(width: 130)
                    Divider()
                    HStack {
                        Spacer()
                        Text("당첨조건")
                            .foregroundColor(.gray2)
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
