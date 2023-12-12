//
//  LottoNumberSheetViewModel.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import Foundation

class LottoNumberSheetViewModel: ObservableObject {
    
    enum Action {
        case tapNumber(Int)
        case toggleFavorite
        case tapFavoriteNumber(LottoFavorite?)
        case save
        case reset
    }
    
    @Published var selected: Set<Int> = []
    @Published var favorites = [LottoFavorite]()
    
    var isContainedFavorites: Bool {
        favorites.filter { $0.numbers == Array(selected).toLottoNumberString }.count == 1
    }
    
    private var services: ServiceProtocol
    
    init(services: ServiceProtocol) {
        self.services = services
        fetchFavorites()
    }
    
    func send(action: Action) {
        switch action {
        case .tapNumber(let number):
            if selected.contains(number) {
                selected.remove(number)
            } else {
                if selected.count > 5 { return }
                selected.insert(number)
            }
        case .toggleFavorite:
            toggleFavorite()
        case .tapFavoriteNumber(let favorite):
            selected = Set(favorite?.numbers?.toLottoNumbers ?? [])
        case .save:
            // TODO: 지금 선택한 번호 저장하기
            return
        case .reset:
            selected = []
            return
        }
    }
    
    func isSelected(_ number: Int) -> Bool {
        selected.contains(number)
    }
    
    // MARK: - Favorites
    private func toggleFavorite() {
        if isContainedFavorites {
            deleteFavorite(Array(selected))
        } else {
            addFavorite(Array(selected))
        }
    }
    
    private func fetchFavorites() {
        favorites = services.lottoService.getFavoriteNumbers()
    }
    
    private func addFavorite(_ numbers: [Int]) {
        do {
            try services.lottoService.add(favoriteNumbers: numbers)
        } catch { print(error.localizedDescription) }
        fetchFavorites()
    }
    
    private func deleteFavorite(_ numbers: [Int]) {
        do {
            try services.lottoService.delete(favoriteNumbers: numbers)
        } catch { print(error.localizedDescription) }
        fetchFavorites()
    }
    
    func isContained(favorite: LottoFavorite) -> Bool {
        favorites.filter { $0.numbers == favorite.numbers }.count == 1
    }
}
