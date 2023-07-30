//
//  SettingView.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        List {
            Section {
                NavigationLink("저장된 로또 결과", destination: SavedLotto())
                NavigationLink("즐겨찾는 로또 번호 조합", destination: SavedLotto())
            }
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SavedLotto: View {
    @EnvironmentObject var data: LottoData
    @FetchRequest(sortDescriptors: []) var lottos: FetchedResults<LottoResult>
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(lottos) { lotto in
                    ScrollView(.horizontal) {
                        HStack {
                            Text("\(lotto.date ?? Date())")
                            Text("\(lotto.lotteryDate ?? "No Lottery Date")")
                            Text("\(lotto.aGroup ?? "aGroup")")
                            Text("\(lotto.bGroup ?? "bGroup")")
                            Text("\(lotto.cGroup ?? "cGroup")")
                            Text("\(lotto.dGroup ?? "dGroup")")
                            Text("\(lotto.eGroup ?? "eGroup")")
                        }
                    }
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
