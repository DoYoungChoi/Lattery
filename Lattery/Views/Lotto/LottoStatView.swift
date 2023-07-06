//
//  LottoStatView.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import SwiftUI

let lastLottoKey: String = "Lotto"

struct LottoStatView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var data: LottoData
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.nth, order: .reverse)
    ]) var lottos: FetchedResults<LottoEntity>
    // @FetchRequest property wrapper – it uses whatever managed object context is available in the environment.
    @State private var lottoStructs: [Lotto] = []
    private var lottoComps: [Lotto] {
        return lottoStructs
    }
    @State private var isFetching: Bool = false
    @AppStorage(lastLottoKey) private var lastLotto: Int = 0
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(lottos) { lotto in
                            HStack {
                                Text("\(lotto.nth)회")
                                    .bold()
                                LottoBall(number: Int(lotto.no1))
                                LottoBall(number: Int(lotto.no2))
                                LottoBall(number: Int(lotto.no3))
                                LottoBall(number: Int(lotto.no4))
                                LottoBall(number: Int(lotto.no5))
                                LottoBall(number: Int(lotto.no6))
                                Image(systemName: "plus")
                                LottoBall(number: Int(lotto.noBonus))
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button("로또 번호 가져오기") {
                    fetchLastLottoData()
                }
            }
            
            if isFetching {
                LoadingView()
            }
        }
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
    
    private func fetchLastLottoData() {
        isFetching.toggle()
        var keepGoing: Bool = true
        
        Task {
            while (keepGoing) {
                do {
                    let lotto = try await data.fetchData(lastLotto + 1)
                    if let lottoE = lotto.toEntity(context: moc) {
                        try moc.save()
                        lastLotto += 1
                    } else {
                        keepGoing = false
                    }
                } catch {
                    print(error)
                    keepGoing = false
                }
            }
            
            isFetching.toggle()
        }
    }
}

struct LottoStatView_Previews: PreviewProvider {
    static var previews: some View {
        LottoStatView()
    }
}
