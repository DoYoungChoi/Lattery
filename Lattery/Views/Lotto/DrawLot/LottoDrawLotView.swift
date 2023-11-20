//
//  LottoDrawLotView.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import SwiftUI

struct LottoDrawLotView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var data: LottoData
    @State private var showNumberBoard: Bool = false
    @State private var isRunning: Bool = false
    private var noData: Bool {
        data.numberGroups[LottoGroup.a]?.contains(0) ?? true
    }

    var body: some View {
        ZStack {
            VStack {
                ForEach(LottoGroup.allCases) { group in
                    HStack {
                        LottoBallRow(group: group,
                                     showNumberBoard: $showNumberBoard)
                    }
                }
                
                DrawLotButton(isRunning: $isRunning, isEnded: $data.isEnded, action: data.drawLot)
            }
        }
        .padding(.horizontal)
        .navigationTitle("로또번호 추첨")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if data.isSaved {
                        data.deleteLottoResult(nil, context: moc)
                    } else {
                        data.saveLottoResult(moc)
                    }
                } label: {
                    Image(data.isSaved ? "heart_fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .shadow(color: .customRed, radius: data.isSaved ? 5 : 0)
                        .opacity(noData || isRunning ? 0.7 : 1)
                }
                .disabled(noData || isRunning)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                RefreshButton(action: data.reset)
                    .opacity(noData || isRunning ? 0.7 : 1)
                    .disabled(noData || isRunning)
            }
        }
        .disabled(isRunning)
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
