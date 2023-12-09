//
//  LottoWinningCheckViewModel.swift
//  Lattery
//
//  Created by dodor on 12/7/23.
//

import Foundation

class LottoWinningCheckViewModel: ObservableObject {
    
    @Published var selectedLotto: LottoEntity?
    @Published var selectedResult: LottoDrawingLotResult?

    var lottos: [LottoEntity] = []
    var drawingLotResults: [LottoDrawingLotResult] = []
    
    var winningNumbers: [Int] {
        selectedLotto?.numbers ?? []
    }
    var bonus: Int { Int(selectedLotto?.bonus ?? 0) }
    var resultNumbers: [LottoNumbers] {
        if let selected = self.selectedResult {
            return [selected.data[.a],
                    selected.data[.b],
                    selected.data[.c],
                    selected.data[.d],
                    selected.data[.e]]
                .filter { $0 != nil }
                .map { $0! }
        } else {
            return []
        }
    }
}
