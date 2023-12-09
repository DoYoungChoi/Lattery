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
    
    var pensions: [PensionEntity] = []
    var drawingLotResults: [PensionDrawingLotResult] = []
    
    var winNumbers: String {
        selectedPension?.numbers ?? ""
    }
    var bonusNumbers: String {
        selectedPension?.bonus ?? ""
    }
    var savedResult: [String] {
        selectedResult?.data ?? []
    }
}
