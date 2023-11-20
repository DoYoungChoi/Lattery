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
    @State private var errorTitle: String = "에러 발생"
    @State private var errorMessage: String? = nil
    @State private var errorAlertPresented: Bool = false
    
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
                LoadingView()
            }
        }
        .onAppear {
            notiManager.requestNotiAuthorization()
        }
        .task { fetchData() }
        .alert(
            errorMessage ?? errorTitle,
            isPresented: $errorAlertPresented
        ) {
            Button("확인", role: .cancel) { }
        }
        .environmentObject(lottoData)
        .environmentObject(pensionData)
        .environmentObject(viewModel)
        .environmentObject(notiManager)
    }
    
    private func fetchData() {
        viewModel.isLoading = true
        Task {
            var result = await lottoData.getLastestData(context: moc)
            if let resultMessage = result {
                errorTitle = "로또 오류"
                errorMessage = resultMessage
                errorAlertPresented = true
                viewModel.isLoading = false
                return
            }
            
            result = await pensionData.getLastestData(context: moc)
            if let resultMessage = result {
                errorTitle = "연금복권 오류"
                errorMessage = resultMessage
                errorAlertPresented = true
                viewModel.isLoading = false
                return
            }
            
            viewModel.isLoading = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
