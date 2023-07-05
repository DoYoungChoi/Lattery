//
//  ContentView.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var data = DrawingLotData()
    @State private var showSideBar: Bool = false
    @State private var page: Page = .lottoDrawLot
    enum Page {
        case lottoDrawLot
        case lottoStat
        case pensionDrawLot
        case pensionStat
        case settings
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    BackgroundView()
                        .opacity(0.1)
                    
                    if page == .lottoDrawLot {
                        LottoDrawLotView()
                    } else if page == .lottoStat {
                        LottoStatView()
                    } else if page == .pensionDrawLot {
                        PensionDrawLotView()
                    } else if page == .pensionStat {
                        PensionStatView()
                    } else if page == .settings {
                        SettingView()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showSideBar.toggle()
                        } label: {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                }
            }
            
            SideBar(show: $showSideBar, page: $page)
        }
        .environmentObject(data)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
