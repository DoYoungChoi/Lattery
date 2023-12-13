//
//  PensionWinningCheckViewModel.swift
//  Lattery
//
//  Created by dodor on 12/7/23.
//

import Foundation

class PensionWinningCheckViewModel: ObservableObject {
    
    @Published var selectedPension: PensionEntity?
    @Published var selectedResult: PensionDrawingLotResult?
    
    @Published var pensions: [PensionEntity] = []
    @Published var drawingLotResults: [PensionDrawingLotResult] = []
    
    var winNumbers: [Int?] {
        selectedPension?.numbers.toPensionNumbers ?? Array(repeating: nil, count: 7)
    }
    var bonusNumbers: [Int?] {
        if selectedPension?.bonus.toPensionNumbers.count == 7 {
            return Array(selectedPension?.bonus.toPensionNumbers[1..<7] ?? ArraySlice<Int?>(repeating: nil, count: 6))
        } else {
            return Array(repeating: nil, count: 6)
        }
    }
    var resultNumbers: [PensionNumbers] {
        selectedResult?.numbers ?? []
    }
    
    private var services: ServiceProtocol
    
    init(services: ServiceProtocol) {
        self.services = services
        self.pensions = self.services.pensionService.getPensionEntities(ascending: false)
        self.drawingLotResults = self.services.pensionService.getPensionDrawingLotResults()
        self.selectedPension = self.pensions.first ?? nil
        self.selectedResult = self.drawingLotResults.first ?? nil
    }
    
    func getPensionEntities() {
        self.pensions = services.pensionService.getPensionEntities(ascending: false)
        selectedPension = self.pensions.first ?? nil
    }
}
