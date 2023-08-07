//
//  LottoResultBoard.swift
//  Lattery
//
//  Created by dodor on 2023/07/08.
//

import SwiftUI
import CoreData

struct LottoResultBoard: View {
    var lotto: LottoEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(verbatim: "\(lotto.round)회 당첨결과")
                .font(.largeTitle)
            
            Text("\(lotto.date?.toDateStringKor ?? "yyyy년 MM월 dd일") 추첨")
                .font(.title3)
                .foregroundColor(.customGray)
            
            HStack {
                LottoBall(number: lotto.no1)
                LottoBall(number: lotto.no2)
                LottoBall(number: lotto.no3)
                LottoBall(number: lotto.no4)
                LottoBall(number: lotto.no5)
                LottoBall(number: lotto.no6)
                Image(systemName: "plus")
                LottoBall(number: lotto.noBonus)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundGray.opacity(0.9))
            }
            
            HStack {
                Image(systemName: "person.2")
                Text("당첨자수")
                Spacer()
                Text("\(lotto.winnerCount)명")
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundGray.opacity(0.9))
            }
            
            HStack {
                Image(systemName: "banknote")
                Text("1등 상금")
                Spacer()
                Text("\(lotto.winnerReward)원")
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundGray.opacity(0.9))
            }
            
            HStack {
                Text("총 판매금액: ")
                Text("\(lotto.totalSalesAmount)원")
                    .bold()
            }
            .font(.caption)
            .foregroundColor(.customGray)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
