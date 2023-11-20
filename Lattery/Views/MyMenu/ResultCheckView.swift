//
//  ResultCheckView.swift
//  Lattery
//
//  Created by dodor on 2023/08/07.
//

import SwiftUI

enum LotteryType: String, Identifiable, CaseIterable {
    case lotto = "로또 6/45"
    case pension = "연금복권720+"
    
    var id: String { self.rawValue }
}

struct ResultCheckView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var lottoData: LottoData
    @EnvironmentObject var pensionData: PensionData
    @EnvironmentObject var viewModel: GeneralViewModel
    @State private var lottery: LotteryType = .lotto
    
    var body: some View {
        VStack {
            LotteryPicker(selection: $lottery)
            
            if lottery == .lotto {
                LottoResultCheckView()
            } else if lottery == .pension {
                PensionResultCheckView()
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("당첨결과 확인")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                RefreshButton {
                    if lottery == .lotto {
                        lottoFetchData()
                    } else if lottery == .pension {
                        pensionFetchData()
                    }
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
    
    private struct LotteryPicker: View {
        @Binding var selection: LotteryType
        
        var body: some View {
            HStack {
                ForEach(LotteryType.allCases) { type in
                    VStack(spacing: 0) {
                        Text(type.id)
                            .padding(.vertical, 3)
                        
                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(.customPink)
                            .opacity(selection == type ? 1 : 0)
                    }
                    .background(.background)
                    .opacity(selection == type ? 1 : 0.3)
                    .onTapGesture {
                        withAnimation {
                            selection = type
                        }
                    }
                }
            }
        }
    }
    
    private func lottoFetchData() {
        viewModel.isLoading = true
        Task {
            var result = await lottoData.getLastestData(context: moc)
            if let resultMessage = result {
                viewModel.errorMessage = resultMessage
                viewModel.errorAlertPresented = true
                viewModel.isLoading = false
                return
            }
            
            viewModel.isLoading = false
        }
    }
    
    private func pensionFetchData() {
        viewModel.isLoading = true
        Task {
            var result = await pensionData.getLastestData(context: moc)
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

struct ResultCheckView_Previews: PreviewProvider {
    static var previews: some View {
        ResultCheckView()
    }
}
