//
//  SettingView.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.managedObjectContext) var moc
//    @EnvironmentObject var lottoData: LottoData
    @EnvironmentObject var notiManager: NotificationManager
    @State private var targetNoti: NotificationManager.Noti? = nil
    private let weekdays: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    private var lottoBuyDays: String {
        notiManager.lottoBuyDay.sorted().map({ weekdays[$0-1] }).joined(separator: " / ")
    }
    private var pensionBuyDays: String {
        notiManager.pensionBuyDay.sorted().map({ weekdays[$0-1] }).joined(separator: " / ")
    }
    
    var body: some View {
        List {
            // MARK: - 알림
            Section(header: Text("알림")) {
                HStack {
                    Text("로또 알림 받기")
                    Spacer()
                    if !notiManager.lottoNotiOn {
                        Toggle("", isOn: $notiManager.lottoNotiOn.animation())
                    }
                }
                if notiManager.lottoNotiOn {
                    VStack(spacing: 4) {
                        Toggle(isOn: $notiManager.lottoOnAirNotiOn) {
                            Text("▶︎ 방송 시작 알림")
                                .padding(.leading, 10)
                        }
                        if notiManager.lottoOnAirNotiOn {
                            HStack {
                                Text("매주 토")
                                Spacer()
                                Text("오후 8시 35분")
                            }
                            .foregroundColor(.accentColor)
                            .padding(.leading, 26)
                        }
                    }
                    .font(.subheadline)
                    
                    VStack(spacing: 4) {
                        Toggle(isOn: $notiManager.lottoBuyNotiOn) {
                            Text("▶︎ 구매 알림")
                                .padding(.leading, 10)
                        }
                        if notiManager.lottoBuyNotiOn {
                            Button {
                                notiManager.targetNoti = .lottoBuy
                                notiManager.showBuyDaySheet = true
                            } label: {
                                HStack {
                                    Text("매주 \(lottoBuyDays)")
                                        .bold()
                                        .padding(.leading, 28)
                                    Spacer()
                                    Text(notiManager.lottoBuyTime.toTimeKor)
                                        .bold()
                                }
                            }
                        }
                    }
                    .font(.subheadline)
                }
                
                HStack {
                    Text("연금복권 알림 받기")
                    Spacer()
                    if !notiManager.pensionNotiOn {
                        Toggle("", isOn: $notiManager.pensionNotiOn.animation())
                    }
                }
                if notiManager.pensionNotiOn {
                    VStack(spacing: 4) {
                        Toggle(isOn: $notiManager.pensionOnAirNotiOn) {
                            Text("▶︎ 방송 시작 알림")
                                .padding(.leading, 10)
                        }
                        if notiManager.pensionOnAirNotiOn {
                            HStack {
                                Text("매주 목")
                                Spacer()
                                Text("오후 7시 5분")
                            }
                            .foregroundColor(.accentColor)
                            .padding(.leading, 26)
                        }
                    }
                    .font(.subheadline)
                    
                    VStack(spacing: 4) {
                        Toggle(isOn: $notiManager.pensionBuyNotiOn) {
                            Text("▶︎ 구매 알림")
                                .padding(.leading, 10)
                        }
                        if notiManager.pensionBuyNotiOn {
                            Button {
                                notiManager.targetNoti = .pensionBuy
                                notiManager.showBuyDaySheet = true
                            } label: {
                                HStack {
                                    Text("매주 \(pensionBuyDays)")
                                        .bold()
                                        .padding(.leading, 28)
                                    Spacer()
                                    Text(notiManager.pensionBuyTime.toTimeKor)
                                        .bold()
                                }
                            }
                        }
                    }
                    .font(.subheadline)
                }
            }
            .tint(.customPink)
            
            // MARK: - 로또
            Section(header: Text("로또6/45")) {
                Button {
                } label: {
                    Text("로또 데이터 가져오기")
                        .foregroundColor(.primary)
                }
                NavigationLink("저장한 로또 추첨번호", destination: SavedLottoNumberView())
                NavigationLink("로또번호 즐겨찾기", destination: LottoFavoriteView())
            }
            
            // MARK: - 연금복권
            Section(header: Text("연금복권720+")) {
                Button {
                } label: {
                    Text("연금복권 데이터 가져오기")
                        .foregroundColor(.primary)
                }
                NavigationLink("저장한 연금복권 추첨번호", destination: SavedPensionNumberView())
            }
        }
        .onAppear {
            notiManager.checkAuthorization()
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $notiManager.showBuyDaySheet) {
            BuyDaySheet()
                .environmentObject(notiManager)
        }
        .alert(
            "설정 앱에서 알림을 허용하시기 바랍니다.",
            isPresented: $notiManager.showAlert
        ) {
            Button("확인") { notiManager.showAlert = false }
            Button("설정으로 이동") {
                notiManager.showAlert = false
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text("설정 앱에서 알림을 끈 경우 앱에서 알림을 받기 위한 설정을 하여도 알림을 받을 수 없습니다. 설정으로 이동하여 알림을 켜주세요.")
                .foregroundColor(.customDarkGray)
        }
    }
}


#Preview {
    SettingView()
}
