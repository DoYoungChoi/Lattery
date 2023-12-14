//
//  LottoFavoriteNumbersView.swift
//  Lattery
//
//  Created by dodor on 12/14/23.
//

import SwiftUI

struct LottoFavoriteNumbersView: View {
    
    @EnvironmentObject private var services: Service
    @ObservedObject var viewModel: SettingViewModel
    
    var body: some View {
        List {
            
            ForEach(viewModel.lottoFavorites) { favorite in
                LottoFavoriteNumbersRow(favorite: favorite)
                .swipeActions {
                    Button(role: .destructive) {
                        viewModel.send(action: .deleteLottoFavorite(favorite))
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            
            if viewModel.lottoFavorites.count < 1 {
                Button {
                    viewModel.send(action: .toggleLottoNumberSheet)
                } label: {
                    Text("즐겨찾기 추가하기")
                }
            }
        }
        .navigationTitle("로또번호 즐겨찾기")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.send(action: .toggleLottoNumberSheet)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $viewModel.showLottoNumberSheet) {
            FavoriteLottoNumberSheet { numbers in
                viewModel.send(action: .addLottoFavorite(numbers))
            }
        }
        .onAppear {
            viewModel.send(action: .openLottoFavorites)
        }
    }
}

private struct LottoFavoriteNumbersRow: View {
    let favorite: LottoFavorite
    var numbers: [Int] {
        favorite.numbers?.toLottoNumbers ?? []
    }
    
    fileprivate init(favorite: LottoFavorite) {
        self.favorite = favorite
    }
    
    fileprivate var body: some View {
        HStack(spacing: 8) {
            ForEach(numbers, id:\.self) { number in
                LottoBall(number: number)
            }
        }
    }
}
#Preview {
    LottoFavoriteNumbersView(viewModel: .init(services: StubService()))
}
