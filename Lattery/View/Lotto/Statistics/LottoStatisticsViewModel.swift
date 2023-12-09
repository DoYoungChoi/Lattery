//
//  LottoStatisticsMainViewModel.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import Foundation
import SwiftUI

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
    var lottos: [LottoEntity] = []
    
    // 통계 페이지 표시 상태
    @Published var phase: Phase = .notRequested
    @Published var page: LottoPageType = .detail
    // 지난 회차
    @Published var ascending: Bool = false
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

    let colorSet: [Color] = [.customYellow, .customBlue, .customRed, .customDarkGray, .customGreen]
    // -- 출현 횟수
    var countData: [GraphData] {
        barSample
        
//        var data: [GraphData] = []
//        for i in 1...45 {
//            let lottoNumbers = lottos.map {
//                var temp = [$0.no1, $0.no2, $0.no3, $0.no4, $0.no5, $0.no6]
//                if self.includeBonus { temp.append($0.noBonus) }
//                return temp
//            }
//            let value = Double(lottoNumbers.filter({ $0.contains(Int16(i)) }).count)
//            
//            data.append(GraphData(name: String(i),
//                                  value: value))
//        }
//        return data
    }
    // -- 출현 비율: 전체 통계 (Pie)
    var totalRatioData: [GraphData] {
        pieSample
        
//        var data: [GraphData] = []
//        let values: [Int] = lottos.reduce([0,0,0,0,0]) { (sum, entity) in
//            var numbers = [entity.no1, entity.no2, entity.no3, entity.no4, entity.no5, entity.no6]
//            if includeBonus { numbers.append(entity.noBonus) }
//            
//            return [
//                sum[0] + numbers.filter({ $0 > 0 && $0 < 11 }).count,
//                sum[1] + numbers.filter({ $0 > 10 && $0 < 21 }).count,
//                sum[2] + numbers.filter({ $0 > 20 && $0 < 31 }).count,
//                sum[3] + numbers.filter({ $0 > 30 && $0 < 41 }).count,
//                sum[4] + numbers.filter({ $0 > 40 && $0 < 45 }).count
//            ]
//        }
//        
//        for (index, color) in colorSet.enumerated() {
//            let range: String = index == 4 ? "41~45" : "\(String(format: "%.0f", index * 10 + 1))~\(index * 10 + 10)"
//            let info = GraphData(name: range,
//                                 value: Double(values[index]),
//                                 color: color)
//            data.append(info)
//        }
//        return data
    }
    // -- 출현 비율: 자리 통계 (Ratio)
    var positionRatioData: [[GraphData]] {
        var data: [[GraphData]] = []
        for i in 0..<7 {
            data.append(ratioSample)
            
//            var infos = [GraphData]()
//            let temp = i == 0 ? lottos.map { $0.no1 }
//                       : i == 1 ? lottos.map { $0.no2 }
//                       : i == 2 ? lottos.map { $0.no3 }
//                       : i == 3 ? lottos.map { $0.no4 }
//                       : i == 4 ? lottos.map { $0.no5 }
//                       : i == 5 ? lottos.map { $0.no6 }
//                       : i == 6 ? lottos.map { $0.noBonus }
//                       : []
//            for (index, color) in colorSet.enumerated() {
//                let value = Double(temp.filter({ $0 > 10 * index && $0 < 10 * index + 11 }).count)
//                let info = GraphData(name: i == 7 ? "보너스" : "\(i+1)번째",
//                                     value: value,
//                                     color: color,
//                                     order: index)
//                infos.append(info)
//            }
//            data.append(infos)
        }
        
        return data
    }
    // 번호 조합 결과 lotto
    var filtered: [LottoEntity] {
        []
    }
    
    func send(action: Action) {
        switch action {
        case .fetch:
            // TODO: 로또 최신 데이터 불러오기
            self.phase = .loading
            return
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
