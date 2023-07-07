//
//  LottoStatView.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import SwiftUI

let lastestLottoKey: String = "Lotto"

struct LottoStatView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var data: LottoData
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.nth, order: .reverse)
    ]) var lottos: FetchedResults<LottoEntity>
    // @FetchRequest property wrapper – it uses whatever managed object context is available in the environment.
    @State private var isFetching: Bool = false
    @AppStorage(lastestLottoKey) private var lastestLotto: Int = 0
    @State private var isAnimating: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                // 최신 로또 당첨 결과
                lastestLottoResult
                
                Spacer()
            }
            
            if isFetching {
                LoadingView()
            }
        }
        .navigationTitle("로또 통계")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    fetchLastLottoData()
                } label: {
                    Label("발바닥", systemImage: isFetching ? "pawprint" : "pawprint.fill")
                }
            }
        }
        .task {
            fetchLastLottoData()
        }
    }
    
    private var lastestLottoResult: some View {
        VStack {
            if let lastestLotto = lottos.first {
                VStack {
                    Text(verbatim: "\(lastestLotto.nth)회 당첨 결과🎊")
                        .font(.title)
                        .bold()
                    
                    Text("\(lastestLotto.date?.toDateStringKor ?? "yyyy년 MM월 dd일") 추첨")
                        .font(.callout)
                        .foregroundColor(.primary.opacity(0.7))
                    
                    ScrollView(.horizontal) {
                        HStack {
                            LottoBall(number: Int(lastestLotto.no1))
                            LottoBall(number: Int(lastestLotto.no2))
                            LottoBall(number: Int(lastestLotto.no3))
                            LottoBall(number: Int(lastestLotto.no4))
                            LottoBall(number: Int(lastestLotto.no5))
                            LottoBall(number: Int(lastestLotto.no6))
                            Image(systemName: "plus")
                            LottoBall(number: Int(lastestLotto.noBonus))
                        }
                    }
                    .padding()
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
                .redacted(reason: isFetching ? .placeholder : [])
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
    
    private func fetchLastLottoData() {
        isFetching.toggle()
        var keepGoing: Bool = true
        
        Task {
            while (keepGoing) {
                do {
                    let lotto = try await data.fetchData(lastestLotto + 1)
                    if let _ = lotto.toEntity(context: moc) {
                        lastestLotto += 1
                    } else {
                        keepGoing = false
                    }
                } catch {
                    print(error)
                    keepGoing = false
                    isAnimating.toggle()
                }
            }
            
            try moc.save()
            isFetching.toggle()
        }
    }
}

//struct LottoStatView_Previews: PreviewProvider {
//    static var previews: some View {
//        LottoStatView()
//    }
//}
