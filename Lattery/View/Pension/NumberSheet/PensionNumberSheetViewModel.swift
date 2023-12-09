//
//  PensionNumberSheetViewModel.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import Foundation

class PensionNumberSheetViewModel: ObservableObject {
    
    enum Action {
        case tapNumber(Int)
        case save
        case reset
    }
    
    func send(action: Action) {
        switch action {
        case .tapNumber(let number):
            // TODO:
            return
        case .save:
            // TODO: 지금 선택한 번호 저장하기
            return
        case .reset:
            // TODO: 번호 선택 초기화
            return
        }
    }
}
