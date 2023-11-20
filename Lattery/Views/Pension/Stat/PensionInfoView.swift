//
//  PensionStatView.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import SwiftUI

struct PensionInfoView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var data: PensionData
    @EnvironmentObject var viewModel: GeneralViewModel
    @State private var isFetching: Bool = false
    @State private var pensions: [Pension] = []
    @State private var page: InfoPage = .detail

    var body: some View {
        VStack {
            InfoPagePicker(selection: $page)
            
            if page == .detail {
                PensionResultList()
                    .padding(.leading, -15)
            } else if page == .stat {
                PensionStatMenuView()
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("연금복권 정보")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                RefreshButton {
                    fetchData()
                }
            }
        }
        .alert(
            viewModel.errorMessage ?? viewModel.errorTitle,
            isPresented: $viewModel.errorAlertPresented
        ) {
            Button("확인", role: .cancel) { }
        }
    }
    
    private func fetchData() {
        viewModel.isLoading = true
        Task {
            var result = await data.getLastestData(context: moc)
            if let resultMessage = result {
                viewModel.errorMessage = resultMessage
                viewModel.errorAlertPresented = true
                viewModel.isLoading = false
                return
            }
            
            viewModel.isLoading = false
        }
    }
}

struct PensionStatView_Previews: PreviewProvider {
    static var previews: some View {
        PensionInfoView()
    }
}
