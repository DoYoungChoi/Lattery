//
//  LottoDrawLotView.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import SwiftUI

struct LottoDrawLotView: View {
    @EnvironmentObject var data: LottoData
    @State private var showNumberBoard: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                ForEach(LottoGroup.allCases) { group in
                    HStack {
                        LottoBallRow(group: group,
                                     showNumberBoard: $showNumberBoard)
                    }
                }
                
                DrawLotButton(isEnded: $data.isEnded, action: data.drawLot)
            }
        }
        .padding()
        .navigationTitle("⭐️로또 번호 추첨⭐️")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                RefreshButton(action: data.reset)
            }
        }
        .sheet(isPresented: $showNumberBoard) {
            LottoNumberBoard()
        }
        .onAppear(perform: data.reset)
    }
}

struct LottoDrawLotView_Previews: PreviewProvider {
    static var previews: some View {
        LottoDrawLotView()
            .environmentObject(LottoData())
    }
}
