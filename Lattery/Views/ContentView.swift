//
//  ContentView.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @StateObject private var lottoData = LottoData()
    @StateObject private var pensionData = PensionData()
    @StateObject private var viewModel = GeneralViewModel()
    @StateObject private var notiManager = NotificationManager()
    @State private var initAlert: Bool = !UserDefaults.standard.bool(forKey: initialOpenKey)
    
    var body: some View {
        ZStack {
            NavigationView {
                MenuView()
                    .padding(.bottom)
            }
            
            if lottoData.isEnded {
                LottoTicket(show: $lottoData.isEnded)
            }
            
            if pensionData.isEnded {
                PensionTicket(show: $pensionData.isEnded)
            }
            
            if viewModel.isLoading {
                LoadingView(text: viewModel.loadingText)
            }
        }
        .onAppear {
            if initAlert { notiManager.initiateNotiAuthorization() }
        }
        .alert(
            "전체 복권정보를 받아오시겠습니까?\n(약 10초 소요)",
            isPresented: $initAlert
        ) {
            Button("취소") {
                UserDefaults.standard.set(true, forKey: initialOpenKey)
            }
            
            Button("가져오기") {
                fetchData()
                UserDefaults.standard.set(true, forKey: initialOpenKey)
            }
        } message: {
            Text("지금 받지 않아도 설정 또는 당첨 정보를 확인하는 페이지에서 데이터를 받아올 수 있습니다.")
        }
        .environmentObject(lottoData)
        .environmentObject(pensionData)
        .environmentObject(viewModel)
        .environmentObject(notiManager)
    }
    
    private func fetchData() {
        // 맨 처음 앱을 실행했을 때 전체 데이터를 다운로드 받을건지 물어보기 위한 용도
        viewModel.isLoading = true
        var lottoFetch = false
        var pensionFetch = false
        Task {
            var result = await lottoData.getLastestData(context: moc)
            if let resultMessage = result {
                viewModel.errorMessage = resultMessage
                viewModel.errorAlertPresented = true
                viewModel.isLoading = false
                return
            }
            lottoFetch = true
            
            viewModel.isLoading = !(lottoFetch && pensionFetch)
        }
        
        Task {
            var result = await pensionData.getLastestData(context: moc)
            if let resultMessage = result {
                viewModel.errorMessage = resultMessage
                viewModel.errorAlertPresented = true
                viewModel.isLoading = false
                return
            }
            pensionFetch = true
            
            viewModel.isLoading = !(lottoFetch && pensionFetch)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
