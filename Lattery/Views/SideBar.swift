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
    @State private var openMenu: [Bool] = [true, true]
    private var moveAndTrans: AnyTransition {
        AnyTransition.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity),
                                 removal: .move(edge: .top).combined(with: .opacity))
    }
    
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
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Image("LatteryLogo")
                            .resizable()
                            .scaledToFit()
                        
                        Rectangle()
                            .fill(Color(uiColor: .systemBackground))
                            .shadow(color: .accentColor.opacity(0.2), radius: 3, x: 0, y: 5)
                            .overlay {
                                Text("바로가기")
                                    .font(.title3)
                                    .bold()
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxHeight: 50)
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                lottoMenu
                                if openMenu[0] {
                                    lottoDrawLotButton
                                        .transition(moveAndTrans)
                                    lottoStatButton
                                        .transition(moveAndTrans)
                                }
                                
                                pensionMenu
                                if openMenu[1] {
                                    pensionDrawLotButton
                                        .transition(moveAndTrans)
                                    pensionStatButton
                                        .transition(moveAndTrans)
                                }
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
        .buttonStyle(.plain)
        .opacity(show ? 1 : 0)
        .ignoresSafeArea()
    }
    
    private var lottoMenu: some View {
        HStack {
            Text("로또 6/45")
                .bold()
            Spacer()
            Button {
                withAnimation {
                    openMenu[0].toggle()
                }
            } label: {
                Image(systemName: "chevron.up")
                    .rotationEffect(Angle(degrees: openMenu[0] ? 180 : 0))
            }
        }
    }
    
    private var lottoDrawLotButton: some View {
        Button {
            page = .lottoDrawLot
            show.toggle()
        } label: {
            HStack {
                Image(systemName: "trophy.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 30)
                    .foregroundColor(.latteYellow)
                Text("로또 번호 추첨")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(uiColor: .systemBackground))
        }
    }
    
    private var lottoStatButton: some View {
        Button {
            page = .lottoStat
            show.toggle()
        } label: {
            HStack {
                Image(systemName: "trophy.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 30)
                    .foregroundColor(.latteBlue)
                Text("로또 통계")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(uiColor: .systemBackground))
        }
    }
    
    private var pensionMenu: some View {
        HStack {
            Text("연금복권720+")
                .bold()
            Spacer()
            Button {
                withAnimation {
                    openMenu[1].toggle()
                }
            } label: {
                Image(systemName: "chevron.up")
                    .rotationEffect(Angle(degrees: openMenu[1] ? 180 : 0))
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
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 30)
                    .foregroundColor(.latteRed)
                Text("연금복권 번호 추첨")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(uiColor: .systemBackground))
        }
    }
    
    private var pensionStatButton: some View {
        Button {
            page = .pensionStat
            show.toggle()
        } label: {
            HStack {
                Image(systemName: "trophy.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 30)
                    .foregroundColor(.latteGreen)
                Text("연금복권 통계")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(uiColor: .systemBackground))
        }
    }

    private var settingsButton: some View {
        Button {
            page = .settings
            show.toggle()
        } label: {
            HStack {
                Text("설정")
                    .bold()
                Spacer()
            }
            .padding()
            .padding(.bottom)
            .foregroundColor(Color(uiColor: .systemBackground))
            .background(Color.accentColor)
        }
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar(show: .constant(true),
                page: .constant(ContentView.Page.lottoDrawLot))
    }
}
