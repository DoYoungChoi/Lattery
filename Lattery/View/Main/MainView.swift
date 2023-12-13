//
//  MainView.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                LottoMenu()
                PensionMenu()
                MyMenu()
            }
            .padding(.horizontal, 20)
            .navigationTitle("MENU")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - 로또 6/45
private struct LottoMenu: View {
    @EnvironmentObject private var services: Service
    
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("로또 6/45")
                .font(.headline)
                .foregroundColor(.primaryColor)
            
            HStack(spacing: 16) {
                NavigationLink("로또 번호추첨", 
                               destination: LottoDrawingLotView(viewModel: .init(services: services)))
                    .buttonStyle(MainButtonStyle(imageName: "lotto_ball"))
                
                NavigationLink("로또 정보", 
                               destination: LottoStatisticsMainView(viewModel: .init(services: services)))
                    .buttonStyle(MainButtonStyle(imageName: "bar_chart"))
            }
        }
    }
}

// MARK: - 연금복권720+
private struct PensionMenu: View {
    @EnvironmentObject private var services: Service
    
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("연금복권720+")
                .font(.headline)
                .foregroundColor(.primaryColor)
            
            HStack(spacing: 16) {
                NavigationLink("연금복권 번호추첨", destination: PensionDrawingLotView(viewModel: .init(services: services)))
                    .buttonStyle(MainButtonStyle(imageName: "lottery_box"))
                
                NavigationLink("연금복권 정보", destination: PensionStatisticsMainView(viewModel: .init(services: services)))
                    .buttonStyle(MainButtonStyle(imageName: "pie_chart"))
            }
        }
    }
}

// MARK: - My메뉴
private struct MyMenu: View {
    fileprivate var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("My메뉴")
                .font(.headline)
                .foregroundColor(.primaryColor)
            
            HStack(spacing: 16) {
                NavigationLink("추첨결과 확인", destination: WinningCheckMainView())
                    .buttonStyle(MainButtonStyle(imageName: "trophy"))
                
                NavigationLink("설정", destination: EmptyView())
                    .buttonStyle(MainButtonStyle(imageName: "gear"))
            }
        }
    }
}

#Preview {
    MainView()
}
