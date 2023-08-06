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
        .animation(nil)
        .buttonStyle(.plain)
        .navigationTitle("전체 메뉴")
        .navigationBarTitleDisplayMode(.large)
    }
}
    
extension MenuView {
    private var lottoDrawLot: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.background)
            .frame(minHeight: textSize * 3, maxHeight: 150)
            .padding(.horizontal)
            .shadow(color: .customGray, radius: 5)
            .overlay {
                Text("로또 번호 추첨")
            }
    }
    
    private var lottoStat: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.background)
            .frame(minHeight: textSize * 3, maxHeight: 150)
            .padding(.horizontal)
            .shadow(color: .customGray, radius: 5)
            .overlay {
                Text("로또 정보")
            }
    }
    
    private var pensionDrawLot: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.background)
            .frame(minHeight: textSize * 3, maxHeight: 150)
            .padding(.horizontal)
            .shadow(color: .customGray, radius: 5)
            .overlay {
                Text("연금복권 번호 추첨")
            }
    }
    
    private var pensionStat: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.background)
            .frame(minHeight: textSize * 3, maxHeight: 150)
            .padding(.horizontal)
            .shadow(color: .customGray, radius: 5)
            .overlay {
                Text("연금복권 통계")
            }
    }
    
    private var setting: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.background)
            .frame(minHeight: textSize * 3, maxHeight: 150)
            .padding(.horizontal)
            .shadow(color: .customGray, radius: 5)
            .overlay {
                Text("설정")
            }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
