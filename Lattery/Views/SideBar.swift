//
//  SideBar.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import SwiftUI

struct SideBar: View {
    @Binding var show: Bool
    @Binding var page: ContentView.Page
    let width: CGFloat = UIScreen.main.bounds.size.width * 0.6
    let refWidth: CGFloat = 300
    
    var body: some View {
        ZStack {
            Color.primary
                .opacity(0.4)
                .onTapGesture {
                    show.toggle()
                }
            
            HStack {
                ZStack {
                    Color(uiColor: .systemBackground)
                    
                    VStack(alignment: .leading) {
                        Image("LatteryLogo")
                            .resizable()
                            .scaledToFit()
                        
                        Rectangle()
                            .fill(Color(uiColor: .systemBackground))
                            .shadow(color: .primary.opacity(0.2), radius: 3, x: 0, y: 5)
                            .overlay {
                                Text("바로가기")
                                    .font(.title3)
                                    .bold()
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxHeight: 50)
                        
                        ScrollView {
                            VStack(alignment: .leading) {
                                Text("로또 6/45")
                                    .font(.footnote)
                                    .bold()
                                
                                lottoDrawLotButton
                                lottoStatButton
                                
                                Text("연금복권720+")
                                    .font(.footnote)
                                    .bold()
                                
                                pensionDrawLotButton
                                pensionStatButton
                                
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        }
                        
                        Spacer()
                        
                        settingsButton
                    }
                }
                .frame(width: width < refWidth ? width : refWidth)
                .offset(x: show ? 0 : -(width < refWidth ? width : refWidth))
                .animation(.default, value: show)
                
                Spacer()
            }
        }
        .opacity(show ? 1 : 0)
        .ignoresSafeArea()
    }
    
    private var lottoDrawLotButton: some View {
        Button {
            page = .lottoDrawLot
            show.toggle()
        } label: {
            HStack {
                Image(systemName: "trophy.circle")
                Spacer()
                Text("로또 번호 추첨")
            }
        }
    }
    
    private var lottoStatButton: some View {
        Button {
            page = .lottoStat
            show.toggle()
        } label: {
            HStack {
                Image(systemName: "trophy.circle")
                Spacer()
                Text("로또 통계")
            }
        }
    }
    
    private var pensionDrawLotButton: some View {
        Button {
            page = .pensionDrawLot
            show.toggle()
        } label: {
            HStack {
                Image(systemName: "trophy.circle")
                Spacer()
                Text("연금복권 번호 추첨")
            }
        }
    }
    
    private var pensionStatButton: some View {
        Button {
            page = .pensionStat
            show.toggle()
        } label: {
            HStack {
                Image(systemName: "trophy.circle")
                Spacer()
                Text("연금복권 통계")
            }
        }
    }

    private var settingsButton: some View {
        Button {
            page = .settings
            show.toggle()
        } label: {
            HStack {
                Image(systemName: "trophy.circle")
                Spacer()
                Text("설정")
            }
        }
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar(show: .constant(true),
                page: .constant(ContentView.Page.lottoDrawLot))
    }
}
