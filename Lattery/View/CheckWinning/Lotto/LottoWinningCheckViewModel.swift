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

    @Published var lottos: [LottoEntity] = []
    @Published var drawingLotResults: [LottoDrawingLotResult] = []
    
    var winningNumbers: [Int] {
        selectedLotto?.numbers ?? []
    }
    var bonus: Int { Int(selectedLotto?.bonus ?? 0) }
    var resultNumbers: [LottoNumbers] {
        selectedResult?.numbers ?? []
    }
    
    private var services: ServiceProtocol
    
    init(services: ServiceProtocol) {
        self.services = services
        self.lottos = self.services.lottoService.getLottoEntities(ascending: false)
        self.drawingLotResults = self.services.lottoService.getLottoDrawingLotResults()
        self.selectedLotto = self.lottos.first ?? nil
        self.selectedResult = self.drawingLotResults.first ?? nil
    }
    
    func getLottoEntity() {
        lottos = services.lottoService.getLottoEntities(ascending: false)
        selectedLotto = lottos.first ?? nil
    }
}
