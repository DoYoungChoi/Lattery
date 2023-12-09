//
//  LottoDrawingLotViewModel.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import Foundation

let lottoDrawingLotresult: [LottoGroup: LottoNumbers] = [
    .a: LottoNumbers(numbers: [1, 11, 21, 31, 41, 20]),
    .b: LottoNumbers(numbers: [1, 11, 21, 31, 41, 20]),
    .c: LottoNumbers(numbers: [1, 11, 21, 31, 41, 20]),
    .d: LottoNumbers(numbers: [1, 11, 21, 31, 41, 20]),
    .e: LottoNumbers(numbers: [1, 11, 21, 31, 41, 20]),
]

class LottoDrawingLotViewModel: ObservableObject {
    
    enum Action {
        case refresh
        case run
        case toggleSave
        case toggleTicket
        case toggleShowPicker
        case changePaw(Paw)
        case toggleNumberSheet
    }
    
    @Published var drawingLotResult: [LottoGroup: LottoNumbers] = [:]
    @Published var isRunning: Bool = false
    @Published var showTicket: Bool = false
    
    @Published var save: Bool = false
    
    @Published var showPicker: Bool = false
    @Published var paw: Paw = .pink
    
    @Published var showNumberSheet: Bool = false
    
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
    
    private func refresh() {
        self.save = false
        self.drawingLotResult = [:]
    }
    
    private func run() {
        self.isRunning = true
        self.drawingLotResult = lottoDrawingLotresult
        self.showTicket.toggle()
        self.isRunning = false
    }
    
    private func toggleSave() {
        self.save.toggle()
    }
}
