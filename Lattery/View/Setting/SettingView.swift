//
//  SettingView.swift
//  Lattery
//
//  Created by dodor on 12/14/23.
//

import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject private var services: Service
    @StateObject var viewModel: SettingViewModel
    
    var body: some View {
        ZStack {
            List {
                NotiSectionView(viewModel: .init(services: services))
                
                LottoSection(viewModel: viewModel)
                
                PensionSection(viewModel: viewModel)
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.large)
            
            if viewModel.phase == .loading {
                LoadingView(phase: $viewModel.phase,
                            work: viewModel.lotteryType == .lotto ? .lotto : .pension)
            } else if viewModel.phase == .fail {
                AlertView(title: "데이터를 가져오는 중\n에러가 발생했습니다.",
                          content: "안정된 네트워크 환경에서\n다시 시도해주시기 바랍니다.") {
                    viewModel.phase = .success
                }
            }
            
            if viewModel.showAlert {
                AlertView(title: "설정 앱에서 알림을 허용하시기 바랍니다.",
                          content: "설정 앱에서 알림을 끈 경우 앱에서 알림을 받기 위한 설정을 하여도 알림을 받을 수 없습니다. 설정으로 이동하여 알림을 켜주세요.",
                          doLabel: "설정으로 이동") {
                    viewModel.send(action: .tapAlertCheckButton)
                } doAction: {
                    viewModel.send(action: .tapAlertMoveButton)
                }
            }
        }
        .onAppear {
            viewModel.send(action: .checkNotiAuthorization)
        }
    }
}

private struct LottoSection: View {
    
    @ObservedObject var viewModel: SettingViewModel
    
    fileprivate init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        Section(header: Text("로또 6/45")) {
            Button {
                viewModel.send(action: .fetch(.lotto))
            } label: {
                Text("로또 데이터 가져오기")
                    .foregroundStyle(Color.accentColor)
            }
            NavigationLink("저장한 로또 추첨번호", 
                           destination: SavedLottoDrawingLotResultView(viewModel: viewModel))
            NavigationLink("로또번호 즐겨찾기",
                           destination: LottoFavoriteNumbersView(viewModel: viewModel))
        }
    }
}

private struct PensionSection: View {
    
    @ObservedObject var viewModel: SettingViewModel
    
    fileprivate init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        Section(header: Text("연금복권720+")) {
            Button {
                viewModel.send(action: .fetch(.pension))
            } label: {
                Text("연금복권 데이터 가져오기")
                    .foregroundStyle(Color.accentColor)
            }
            NavigationLink("저장한 연금복권 추첨번호", 
                           destination: SavedPensionDrawingLotResultView(viewModel: viewModel))
        }
    }
}

#Preview {
    NavigationView {
        SettingView(viewModel: .init(services: StubService()))
    }
}
