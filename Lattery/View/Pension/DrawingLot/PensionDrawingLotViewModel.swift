//
//  PensionDrawingLotViewModel.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import Foundation

let pensionDrawingLotResult: [[Int]] = [
    [1,2,3,4,5,6,7],
    [2,3,4,5,6,7,8],
    [3,4,5,6,7,8,9],
    [4,5,6,7,8,9,0],
    [5,6,7,8,9,0,1]
]

class PensionDrawingLotViewModel: ObservableObject {
    
    enum Action {
        case refresh
        case run
        case toggleSave
        case toggleTicket
        case toggleShowPicker
        case changePaw(Paw)
        case toggleNumberSheet
    }
    
    @Published var drawingLotResult: [[Int?]] = []
    @Published var isRunning: Bool = false
    @Published var showTicket: Bool = false
    
    @Published var save: Bool = false
    
    @Published var showPicker: Bool = false
    @Published var paw: Paw = .pink
    
    @Published var showNumberSheet: Bool = false
    
    init() {
        resetResult()
    }
    
    func send(action: Action) {
        switch action {
        case .refresh:
            self.refresh()
        case .run:
            self.run()
        case .toggleSave:
            self.toggleSave()
        case .toggleTicket:
            self.showTicket.toggle()
        case .toggleShowPicker:
            self.showPicker.toggle()
        case .changePaw(let paw):
            self.paw = paw
        case .toggleNumberSheet:
            self.showNumberSheet.toggle()
        }
    }
    
    private func resetResult() {
        self.drawingLotResult = (1...5).map { [$0] + Array(repeating: nil, count: 6) }
    }
    
    private func refresh() {
        self.save = false
        resetResult()
    }
    
    private func run() {
        self.isRunning = true
        self.drawingLotResult = pensionDrawingLotResult
        self.showTicket.toggle()
        self.isRunning = false
    }
    
    private func toggleSave() {
        self.save.toggle()
    }
}
