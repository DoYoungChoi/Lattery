//
//  LottoStatisticsType.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import Foundation

enum LottoPageType: String, CaseIterable, Identifiable {
    case detail = "지난 회차"
    case statistics = "통계"
    
    var id: String { rawValue }
}

enum LottoStatisticsType: String, CaseIterable, Identifiable {
    case count = "출현 횟수"
    case color = "출현 비율"
    case combination = "번호 조합"
    
    var id: String { rawValue }
}
