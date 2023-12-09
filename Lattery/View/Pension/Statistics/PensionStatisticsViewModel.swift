//
//  PensionStatisticsViewModel.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

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
    var pensions: [PensionEntity] = []
    
    // 통계 페이지 표시 상태
    @Published var phase: Phase = .notRequested
    @Published var page: PensionPageType = .detail
    // 지난 회차
    @Published var ascending: Bool = false
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
    
    let colorSet: [Color] = [.gray1, .customRed, .customOrange, .customYellow, .customGreen, .customLightBlue, .customBlue, .customPurple, .customPink, .customDarkGray]
    // -- 출현 비율: 전체 통계 (Pie)
    var totalRatioData: [GraphData] {
        pieSample
    }
    // -- 출현 비율: 자리 통계 (Ratio)
    var positionRatioData: [[GraphData]] {
        var data: [[GraphData]] = []
        for i in 0..<7 {
            data.append(ratioSample)
        }
        return data
    }
    // 번호 조합 결과 pension
    var filtered: [PensionEntity] {
        []
    }
    
    func send(action: Action) {
        switch action {
        case .fetch:
            // TODO: 연금복권 최신 데이터 불러오기
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
