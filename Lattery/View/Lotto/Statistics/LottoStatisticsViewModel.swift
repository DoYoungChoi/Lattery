//
//  LottoStatisticsMainViewModel.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import Foundation
import SwiftUI

@MainActor
class LottoStatisticsViewModel: ObservableObject {
    
    enum Action {
        case fetch
        case changePage(LottoPageType)
        // 통계
        case changeType(LottoStatisticsType)
        case toggleIncludeBonus
        case changeRatioType(RatioType)
        case toggleNumberBoard
    }
    
    // 데이터
    @Published var lottos: [LottoEntity] = []
    
    // 통계 페이지 표시 상태
    @Published var phase: Phase = .notRequested {
        didSet {
            if phase == .success || phase == .fail {
                self.lottos = self.services.lottoService.getLottoEntities(ascending: self.ascending)
                self.phase = .notRequested
            }
        }
    }
    @Published var page: LottoPageType = .detail
    // 지난 회차
    @Published var ascending: Bool = false {
        didSet {
            self.lottos = self.services.lottoService.getLottoEntities(ascending: self.ascending)
        }
    }
    // 통계
    @Published var statType: LottoStatisticsType = .count
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
    @Published var fixedNumbers: LottoNumbers? = .init(numbers: [])

    let colorSet: [Color] = [.customYellow, .customBlue, .customRed, .customDarkGray, .customGreen]
    // -- 출현 횟수
    var countData: [GraphData] {
        var data: [GraphData] = []
        for i in 1...45 {
            let lottoNumbers = lottos.map {
                var temp = $0.numbers
                if self.includeBonus { temp.append(Int($0.bonus)) }
                return temp
            }
            let value = Double(lottoNumbers.filter({ $0.contains(i) }).count)
            
            data.append(GraphData(name: String(i),
                                  value: value))
        }
        
        switch countMode {
        case .ordered:
            return data
        case .sorted:
            return data.sorted {
                if $0.value > $1.value { return true }
                if $0.value == $1.value && $0.name < $1.name { return true }
                return false
            }
        }
    }
    // -- 출현 비율: 전체 통계 (Pie)
    var totalRatioData: [GraphData] {
        var data: [GraphData] = []
        let values: [Int] = lottos.reduce([0,0,0,0,0]) { (sum, entity) in
            if includeBonus { entity.numbers.append(Int(entity.bonus)) }
            
            return [
                sum[0] + entity.numbers.filter({ $0 > 0 && $0 < 11 }).count,
                sum[1] + entity.numbers.filter({ $0 > 10 && $0 < 21 }).count,
                sum[2] + entity.numbers.filter({ $0 > 20 && $0 < 31 }).count,
                sum[3] + entity.numbers.filter({ $0 > 30 && $0 < 41 }).count,
                sum[4] + entity.numbers.filter({ $0 > 40 && $0 < 45 }).count
            ]
        }
        
        for (index, color) in colorSet.enumerated() {
            let range: String = index == 4 ? "41~45" : "\(String(format: "%.0f", index * 10 + 1))~\(index * 10 + 10)"
            let info = GraphData(name: range,
                                 value: Double(values[index]),
                                 color: color)
            data.append(info)
        }
        return data
    }
    // -- 출현 비율: 자리 통계 (Ratio)
    var positionRatioData: [[GraphData]] {
        var data: [[GraphData]] = []
        for i in 0..<7 {
            var infos = [GraphData]()
            let temp = i < 6 
                       ? lottos.map({ $0.numbers[i] })
                       : lottos.map { Int($0.bonus) }
            for (index, color) in colorSet.enumerated() {
                let value = Double(temp.filter({ $0 > 10 * index && $0 < 10 * index + 11 }).count)
                let info = GraphData(name: i == 7 ? "보너스" : "\(i+1)번째",
                                     value: value,
                                     color: color,
                                     order: index)
                infos.append(info)
            }
            data.append(infos)
        }
        return data
    }
    // 번호 조합 결과 lotto
    var filtered: [LottoEntity] {
        if let fixedNumbers = fixedNumbers,
           !fixedNumbers.numbers.isEmpty {
            if includeBonus {
                return lottos.filter { lotto in
                    var contain: Bool = true
                    fixedNumbers.numbers.forEach {
                        contain = contain && (lotto.numbers.contains($0) || lotto.bonus == $0)
                    }
                    return contain
                }
            } else {
                return lottos.filter { lotto in
                    var contain: Bool = true
                    fixedNumbers.numbers.forEach { contain = contain && lotto.numbers.contains($0) }
                    return contain
                }
            }
        } else {
            return []
        }
    }
    
    private var services: ServiceProtocol
    
    init(services: ServiceProtocol) {
        self.services = services
        self.lottos = self.services.lottoService.getLottoEntities(ascending: self.ascending)
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
