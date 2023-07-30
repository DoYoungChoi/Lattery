//
//  ContentView.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var lottoData = LottoData()
    @StateObject private var pensionData = PensionData()
    @ScaledMetric(relativeTo: .body) var textSize = 16
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Rectangle().fill(.background).frame(height: 1)
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("로또 6/45")
                                .bold()
                                .padding(.horizontal)
                            NavigationLink(destination: LottoDrawLotView()) {
                                lottoDrawLot
                            }
                            NavigationLink(destination: LottoStatView()) {
                                lottoStat
                            }
                            
                            Text("연금복권720+")
                                .bold()
                                .padding(.horizontal)
                            NavigationLink(destination: PensionDrawLotView()) {
                                pensionDrawLot
                            }
                            NavigationLink(destination: PensionStatView()) {
                                pensionStat
                            }
                            
                            Text("MY 메뉴")
                                .bold()
                                .padding(.horizontal)
                            NavigationLink(destination: SettingView()) {
                                setting
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.plain)
                }
                .navigationTitle("전체 메뉴")
                .navigationBarTitleDisplayMode(.large)
            }
            
            if lottoData.isEnded {
                LottoTicket(show: $lottoData.isEnded)
            }
        }
        .environmentObject(lottoData)
        .environmentObject(pensionData)
    }
    
    private var lottoDrawLot: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.background)
            .frame(minHeight: textSize * 3, maxHeight: 150)
            .padding(.horizontal)
            .shadow(color: .primary.opacity(0.4), radius: 5)
            .overlay {
                Text("로또 번호 추첨")
            }
    }
    
    private var lottoStat: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.background)
            .frame(minHeight: textSize * 3, maxHeight: 150)
            .padding(.horizontal)
            .shadow(color: .primary.opacity(0.4), radius: 5)
            .overlay {
                Text("로또 통계")
            }
    }
    
    private var pensionDrawLot: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.background)
            .frame(minHeight: textSize * 3, maxHeight: 150)
            .padding(.horizontal)
            .shadow(color: .primary.opacity(0.4), radius: 5)
            .overlay {
                Text("연금복권 번호 추첨")
            }
    }
    
    private var pensionStat: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.background)
            .frame(minHeight: textSize * 3, maxHeight: 150)
            .padding(.horizontal)
            .shadow(color: .primary.opacity(0.4), radius: 5)
            .overlay {
                Text("연금복권 통계")
            }
    }
    
    private var setting: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.background)
            .frame(minHeight: textSize * 3, maxHeight: 150)
            .padding(.horizontal)
            .shadow(color: .primary.opacity(0.4), radius: 5)
            .overlay {
                Text("설정")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
