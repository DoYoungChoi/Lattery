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
        case disappear
    }
    
    @Published var drawingLotResult: [PensionNumbers] = []
    @Published var isRunning: Bool = false
    @Published var showTicket: Bool = false
    
    @Published var save: Bool = false
    
    @Published var showPicker: Bool = false
    @Published var paw: Paw = .pink
    
    @Published var fixedNumbers: [Int?] = [] {
        didSet {
            self.drawingLotResult = (1...5).map {
                PensionNumbers(numbers: [$0] + Array(fixedNumbers[1..<7]),
                               fixedNumbers: [nil] + Array(fixedNumbers[1..<7]))
            }
        }
    }
    @Published var showNumberSheet: Bool = false
    
    private var services: ServiceProtocol
    private var timer: Timer? = nil
    private var saveId: String?
    
    init(services: ServiceProtocol) {
        self.services = services
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
        case .disappear:
            self.stopRunning()
        }
    }
    
    private func resetResult() {
        self.drawingLotResult = (1...5).map {
            PensionNumbers(numbers: [$0] + Array(repeating: nil, count: 6))
        }
        self.fixedNumbers = Array(repeating: nil, count: 7)
    }
    
    private func refresh() {
        self.save = false
        resetResult()
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
            let drawinglot: PensionNumbers = self.services.pensionService.drawLot(contain: self.fixedNumbers)
            self.drawingLotResult = (1...5).map {
                PensionNumbers(numbers: [$0] + Array(drawinglot.numbers[1..<7]),
                               fixedNumbers: [nil] + Array(self.fixedNumbers[1..<7]))
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
                try services.pensionService.delete(drawingLotNumbersById: saveId ?? "")
            } catch { print(error.localizedDescription) }
        } else {
            do {
                saveId = try services.pensionService.add(drawingLotNumbers: drawingLotResult.map { $0.numbers })
            } catch { print(error.localizedDescription) }
        }
        
        self.save.toggle()
    }
}
