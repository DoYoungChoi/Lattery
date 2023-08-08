//
//  MenuView.swift
//  Lattery
//
//  Created by dodor on 2023/08/01.
//

import SwiftUI

struct MenuView: View {
    @ScaledMetric(relativeTo: .body) var textSize = 16
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // MARK: - 로또 6/45
            Text("로또 6/45")
                .bold()
            HStack {
                NavigationLink(destination: LottoDrawLotView()) {
                    lottoDrawLot
                }
                NavigationLink(destination: LottoInfoView()) {
                    lottoStat
                }
            }
            
            // MARK: - 연금복권720+
            Text("연금복권720+")
                .bold()
            HStack {
                NavigationLink(destination: PensionDrawLotView()) {
                    pensionDrawLot
                }
                NavigationLink(destination: PensionInfoView()) {
                    pensionStat
                }
            }
            
            // MARK: - My Menu
            Text("MY MENU")
                .bold()
            HStack {
                NavigationLink(destination: ResultCheckView()) {
                    resultCheck
                }
                NavigationLink(destination: SettingView()) {
                    setting
                }
            }
        }
        .padding(.horizontal)
        .animation(nil)
        .buttonStyle(.plain)
        .navigationTitle("MENU")
        .navigationBarTitleDisplayMode(.large)
    }
}
    
extension MenuView {
    private var lottoDrawLot: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.background)
            .shadow(color: .customGray.opacity(0.7), radius: 5)
            .overlay {
                VStack {
                    Image("lotto_ball")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                    Text("로또번호 추첨")
                }
            }
    }
    
    private var lottoStat: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.background)
            .shadow(color: .customGray.opacity(0.7), radius: 5)
            .overlay {
                VStack {
                    Image("bar_chart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                    Text("로또 정보")
                }
            }
    }
    
    private var pensionDrawLot: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.background)
            .shadow(color: .customGray.opacity(0.7), radius: 5)
            .overlay {
                VStack {
                    Image("lottery_box")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                    Text("연금복권번호 추첨")
                }
            }
    }
    
    private var pensionStat: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.background)
            .shadow(color: .customGray.opacity(0.7), radius: 5)
            .overlay {
                VStack {
                    Image("pie_chart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                    Text("연금복권 정보")
                }
            }
    }
    
    private var resultCheck: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.background)
            .shadow(color: .customGray.opacity(0.7), radius: 5)
            .overlay {
                VStack {
                    Image("trophy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                    Text("당첨결과 확인")
                }
            }
    }
    
    private var setting: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.background)
            .shadow(color: .customGray.opacity(0.7), radius: 5)
            .overlay {
                VStack {
                    Image("gear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                    Text("설정")
                }
            }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
