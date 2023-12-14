//
//  NotiSection.swift
//  Lattery
//
//  Created by dodor on 12/14/23.
//

import SwiftUI

struct NotiSectionView: View {
    
    @ObservedObject var viewModel: SettingViewModel
    
    var body: some View {
        Section(header: Text("알림")) {
            // 로또
            LottoNotiSection(viewModel: viewModel)
            
            // 연금복권
            PensionNotiSection(viewModel: viewModel)
        }
        .tint(.accentColor)
        .sheet(isPresented: $viewModel.showBuyDaysSheet) {
            BuyDaysSheet(viewModel: viewModel)
        }
    }
}

private struct LottoNotiSection: View {
    
    @ObservedObject var viewModel: SettingViewModel
    
    fileprivate init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        Group {
            Toggle("로또 알림 받기", isOn: $viewModel.lottoNotiOn.animation())
            if viewModel.lottoNotiOn {
                VStack(spacing: 4) {
                    Toggle("방송 시작 알림", isOn: $viewModel.lottoOnAirNotiOn)
                        .foregroundStyle(Color.gray3)
                    if viewModel.lottoOnAirNotiOn {
                        HStack {
                            Text("매주 토")
                            Spacer()
                            Text("오후 8시 35분")
                        }
                        .foregroundStyle(Color.gray2)
                    }
                }
                .padding(.leading, 20)
                
                VStack(spacing: 4) {
                    Toggle("구매 알림", isOn: $viewModel.lottoBuyNotiOn)
                        .foregroundStyle(Color.gray3)
                    if viewModel.lottoBuyNotiOn {
                        Button{
                            viewModel.send(action: .toggleBuyDaysSheet(.lotto))
                        } label: {
                            HStack {
                                Text("매주 \(viewModel.days(for: .lotto))")
                                Spacer()
                                Text("\(viewModel.lottoBuyTime.toTimeKor)")
                            }
                            .foregroundColor(.accentColor)
                        }
                    }
                }
                .padding(.leading, 20)
            }
        }
    }
}

private struct PensionNotiSection: View {
    
    @ObservedObject var viewModel: SettingViewModel
    
    fileprivate init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        Group {
            Toggle("연금복권 알림 받기", isOn: $viewModel.pensionNotiOn.animation())
            if viewModel.pensionNotiOn {
                VStack(spacing: 4) {
                    Toggle("방송 시작 알림", isOn: $viewModel.pensionOnAirNotiOn)
                        .foregroundStyle(Color.gray3)
                    if viewModel.pensionOnAirNotiOn {
                        HStack {
                            Text("매주 목")
                            Spacer()
                            Text("오후 7시 5분")
                        }
                        .foregroundStyle(Color.gray2)
                    }
                }
                .padding(.leading, 20)
                
                VStack(spacing: 4) {
                    Toggle("구매 알림", isOn: $viewModel.pensionBuyNotiOn)
                        .foregroundStyle(Color.gray3)
                    if viewModel.pensionBuyNotiOn {
                        Button{
                            viewModel.send(action: .toggleBuyDaysSheet(.pension))
                        } label: {
                            HStack {
                                Text("매주 \(viewModel.days(for: .pension))")
                                Spacer()
                                Text("\(viewModel.pensionBuyTime.toTimeKor)")
                            }
                            .foregroundColor(.accentColor)
                        }
                    }
                }
                .padding(.leading, 20)
            }
        }
    }
}

#Preview {
    NotiSectionView(viewModel: .init(services: StubService()))
}
