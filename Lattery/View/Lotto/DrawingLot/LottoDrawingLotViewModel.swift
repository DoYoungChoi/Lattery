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
        case toggleNumberSheet(LottoGroup)
        case disappear
    }
    
    @Published var drawingLotResult: [LottoGroup: LottoNumbers] = [:]
    @Published var isRunning: Bool = false
    @Published var showTicket: Bool = false
    
    @Published var save: Bool = false
    
    @Published var showPicker: Bool = false
    @Published var paw: Paw = .pink
    
    @Published var showNumberSheet: Bool = false
    
    var group: LottoGroup = .a
    
    private var services: ServiceProtocol
    private var timer: Timer? = nil
    private var saveId: String?
    
    init(services: ServiceProtocol) {
        self.services = services
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
        case .toggleNumberSheet(let group):
            self.group = group
            if drawingLotResult[group] == nil { drawingLotResult[group] = LottoNumbers(numbers: []) }
            self.showNumberSheet.toggle()
        case .disappear:
            self.stopRunning()
        }
    }
    
    private func refresh() {
        self.save = false
        self.drawingLotResult = [:]
    }
    
    private func run() {
        self.save = false
        self.isRunning = true
        self.drawLot()
    }
    
    private func drawLot() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        var times = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            for group in LottoGroup.allCases {
                self.drawingLotResult[group] = self.services.lottoService.drawLot(contain: self.drawingLotResult[group]?.fixedNumbers ?? [])
            }
            times += 1
            
            if times > 20 {
                self.stopRunning()
                self.showTicket.toggle()
            }
        }
    }
    
    private func stopRunning() {
        if timer != nil && timer!.isValid {
            timer!.invalidate()
        }
        timer = nil
        
        self.isRunning = false
    }
    
    private func toggleSave() {
        if save {
            do {
                try services.lottoService.delete(drawingLotNumbersById: saveId ?? "")
            } catch { print(error.localizedDescription) }
        } else {
            do {
                saveId = try services.lottoService.add(drawingLotNumbers: drawingLotResult.map { $0.value.numbers })
            } catch { print(error.localizedDescription) }
        }
        
        save.toggle()
    }
}
