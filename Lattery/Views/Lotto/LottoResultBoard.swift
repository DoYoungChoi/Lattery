//
//  LottoResultBoard.swift
//  Lattery
//
//  Created by dodor on 2023/07/08.
//

import SwiftUI
import CoreData

struct LottoResultBoard: View {
    @FetchRequest var lottos: FetchedResults<LottoEntity>
    @State private var isAnimating: Bool = false
    
    init() {
        // Core Data 처리
        let request: NSFetchRequest<LottoEntity> = LottoEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \LottoEntity.round, ascending: false)
        ]

        request.fetchLimit = 1
        _lottos = FetchRequest(fetchRequest: request)
        
        // 혹시 상황에 isAnimation 시작
        isAnimating.toggle()
    }
    
    var body: some View {
        VStack {
            if let lastestLotto = lottos.first {
                VStack {
                    Text(verbatim: "\(lastestLotto.round)회 당첨 결과🎊")
                        .font(.title)
                        .bold()
                    
                    Text("\(lastestLotto.date?.toDateStringKor ?? "yyyy년 MM월 dd일") 추첨")
                        .font(.callout)
                        .foregroundColor(.primary.opacity(0.7))
                    
                    HStack {
                        LottoBall(number: lastestLotto.no1)
                        LottoBall(number: lastestLotto.no2)
                        LottoBall(number: lastestLotto.no3)
                        LottoBall(number: lastestLotto.no4)
                        LottoBall(number: lastestLotto.no5)
                        LottoBall(number: lastestLotto.no6)
                        Image(systemName: "plus")
                        LottoBall(number: lastestLotto.noBonus)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white.opacity(0.5))
                    }
                    
                    HStack {
                        Image(systemName: "person.2")
//                        Text("당첨자수")
                        Spacer()
                        Text("\(lastestLotto.winnerCount)명")
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white.opacity(0.5))
                    }
                    
                    HStack {
                        Image(systemName: "banknote")
//                        Text("1등 상금")
                        Spacer()
                        Text("\(lastestLotto.winnerReward)원")
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white.opacity(0.5))
                    }
                }
                .padding()
            } else {
                ZStack {
                    // 업데이트 화살표
                    HStack {
                        Spacer()
                        Image(systemName: "arrowshape.backward.fill")
                            .rotationEffect(Angle(degrees: 90))
                            .offset(x: -3, y: isAnimating ? 15 : 5)
                            .animation(.default.repeatForever().speed(1), value: isAnimating)
                    }
                    .frame(maxHeight: .infinity, alignment: .topTrailing)
                    
                    VStack {
                        Text(verbatim: "로또 당첨 결과🎊")
                            .font(.title)
                            .bold()
                        
                        Text("❝최신 데이터 받아오기❞를\n 다시 시도하세요.")
                            .bold()
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white.opacity(0.5))
                            }
                    }
                    .padding()
                }
                .frame(maxHeight: 200)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.primary.opacity(0.1))
        }
        .padding()
    }
}

struct LottoResultBoard_Previews: PreviewProvider {
    static var previews: some View {
        LottoResultBoard()
    }
}
