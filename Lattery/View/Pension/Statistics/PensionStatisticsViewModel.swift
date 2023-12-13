//
//  PensionStatisticsViewModel.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

@MainActor
class PensionStatisticsViewModel: ObservableObject {
    
    enum Action {
        case fetch
        case changePage(PensionPageType)
        // 통계
        case changeType(PensionStatisticsType)
        case toggleIncludeBonus
        case changeRatioType(RatioType)
        case toggleNumberBoard
    }
    
    // 데이터
    @Published var pensions: [PensionEntity] = []
    
    // 통계 페이지 표시 상태
    @Published var phase: Phase = .notRequested {
        didSet {
            if phase == .success || phase == .fail {
                self.pensions = self.services.pensionService.getPensionEntities(ascending: self.ascending)
                self.phase = .notRequested
            }
        }
    }
    @Published var page: PensionPageType = .detail
    // 지난 회차
    @Published var ascending: Bool = false {
        didSet {
            self.pensions = self.services.pensionService.getPensionEntities(ascending: self.ascending)
        }
    }
    // 통계
    @Published var statType: PensionStatisticsType = .color
    @Published var includeBonus: Bool = false
    @Published var countMode: CountMode = .ordered
    enum CountMode: String, Identifiable, CaseIterable {
        case ordered = "번호순"
        case sorted = "당첨횟수순"
        var id: String { rawValue }
    }
    @Published var ratioType: RatioType = .total
    enum RatioType: String, CaseIterable, Identifiable {
        case total = "전체 통계"
        case position = "자리 통계"
        var id: String { rawValue }
    }
    
    @Published var showNumberSheet: Bool = false
    @Published var fixedNumbers: [Int?] = []
    
    let colorSet: [Color] = [.gray1, .customRed, .customOrange, .customYellow, .customGreen, .customLightBlue, .customBlue, .customPurple, .customPink, .customDarkGray]
    // -- 출현 비율: 전체 통계 (Pie)
    var totalRatioData: [GraphData] {
        var data = [GraphData]()
        let values: [Int] = pensions.reduce([0,0,0,0,0,0,0,0,0,0]) { (sum, entity) in
            var numbers: [Int?] = entity.numbers.toPensionNumbers
            if includeBonus { numbers += entity.bonus.toPensionNumbers }
            
            return (0...9).map { index in
                sum[index] + numbers.filter({ $0 == index }).count
            }
        }
        
        for (index, color) in colorSet.enumerated() {
            let info = GraphData(name: String(index),
                                 value: Double(values[index]),
                                 color: color)
            data.append(info)
        }
        return data
    }
    // -- 출현 비율: 자리 통계 (Ratio)
    var positionRatioData: [[GraphData]] {
        var data: [[GraphData]] = []
        func name(index: Int) -> String {
            switch (index) {
                case 0: return "조"
                case 1: return "십만"
                case 2: return "만"
                case 3: return "천"
                case 4: return "백"
                case 5: return "십"
                case 6: return "일"
                default: return ""
            }
        }
        
        for i in 0..<7 {
            var infos = [GraphData]()
            
            var positionNumbers = pensions.map {
                let numbers = $0.numbers.toPensionNumbers
                if numbers.count > i { return numbers[i] }
                return -1
            }
            
            if i > 0 && includeBonus {
                let bonus = pensions.map {
                    let bonusNumbers = $0.bonus.toPensionNumbers
                    if bonusNumbers.count > i { return bonusNumbers[i] }
                    return -1
                }
                positionNumbers += bonus
            }
            
            for (index, color) in colorSet.enumerated() {
                let value = positionNumbers.filter({ $0 == index }).count
                let info = GraphData(name: name(index: i),
                                     value: Double(value),
                                     color: color,
                                     order: index)
                infos.append(info)
            }
            
            data.append(infos)
        }
        return data
    }
    // 번호 조합 결과 pension
    var filtered: [PensionEntity] {
        if fixedNumbers.isEmpty || fixedNumbers.filter({ $0 != nil }).count == 0 { return [] }
        if fixedNumbers.count < 7 {
            fixedNumbers += Array(repeating: nil, count: 7-fixedNumbers.count)
        }
        return pensions.filter { pension in
            var numbers: [Int?] = pension.numbers.toPensionNumbers
            var isContained: Bool = true
            for (index, fixedNumber) in fixedNumbers.enumerated() {
                if fixedNumber == nil { continue }
                if numbers.count > index {
                    isContained = isContained && (numbers[index] == fixedNumber)
                }
            }
            
            if includeBonus && !isContained {
                var bonus: [Int?] = pension.bonus.toPensionNumbers
                isContained = true
                for (index, fixedNumber) in fixedNumbers.enumerated() {
                    if fixedNumber == nil { continue }
                    if bonus.count > index {
                        isContained = isContained && (bonus[index] == fixedNumber)
                    }
                }
            }
            
            return isContained
        }
    }
    
    private var services: ServiceProtocol
    
    init(services: ServiceProtocol) {
        self.services = services
        self.pensions = self.services.pensionService.getPensionEntities(ascending: self.ascending)
    }
    
    func send(action: Action) {
        switch action {
        case .fetch:
            self.phase = .loading
        case .changePage(let page):
            self.page = page
        case .changeType(let type):
            self.statType = type
        case .toggleIncludeBonus:
            self.includeBonus.toggle()
        case .changeRatioType(let ratioType):
            self.ratioType = ratioType
        case .toggleNumberBoard:
            self.showNumberSheet.toggle()
        }
    }
}
