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
        case tapFavorite
        case save
        case reset
    }
    
    @Published var selected: Set<Int> = []
    
    var isContainedFavoriteNumberSet: Bool {
        // TODO: 즐겨찾기 번호 모음(FavoriteNumberSet)에 지금 선택한 번호(selected)가 포함되어 있는지
        false
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
        case .tapFavorite:
            // TODO: 하트 버튼 눌렀을 때 즐겨찾기 번호 모음에 추가/삭제
            return
        case .save:
            // TODO: 지금 선택한 번호 저장하기
            return
        case .reset:
            // TODO: 번호 선택 초기화
            return
        }
    }
    
    func isSelected(_ number: Int) -> Bool {
        selected.contains(number)
    }
    
}
