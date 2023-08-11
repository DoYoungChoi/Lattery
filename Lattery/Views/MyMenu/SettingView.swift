//
//  SettingView.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var lottoData: LottoData
    @EnvironmentObject var pensionData: PensionData
    @EnvironmentObject var viewModel: GeneralViewModel
    @State private var alertLotto: Bool = true
    @State private var alertPension: Bool = true
    
    var body: some View {
        List {
            // MARK: - 알림
            Section(header: Text("알림")) {
                Toggle("로또 알림 허용", isOn: $alertLotto)
                Toggle("연금복권 알림 허용", isOn: $alertPension)
            }
            .tint(.customPink)
            
            // MARK: - 로또
            Section(header: Text("로또6/45")) {
                Button {
                    fetchLottoData()
                } label: {
                    Text("로또 데이터 가져오기")
                        .foregroundColor(.primary)
                }
                NavigationLink("저장한 로또 추첨번호", destination: SavedLottoNumberView())
                NavigationLink("로또번호 즐겨찾기", destination: LottoFavoritesView())
            }
            
            // MARK: - 연금복권
            Section(header: Text("연금복권720+")) {
                Button {
                    fetchPensionData()
                } label: {
                    Text("연금복권 데이터 가져오기")
                        .foregroundColor(.primary)
                }
                NavigationLink("저장한 연금복권 추첨번호", destination: SavedPensionNumberView())
            }
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func fetchLottoData() {
        viewModel.isLoading = true
        Task {
            let resultMessage = await lottoData.fetchAllData(context: moc)
            
            viewModel.isLoading = false
        }
    }
    
    private func fetchPensionData() {
        viewModel.isLoading = true
        Task {
            let resultMessage = await pensionData.fetchAllData(context: moc)
            
            viewModel.isLoading = false
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
