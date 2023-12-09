//
//  PensionStatisticsType.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import Foundation

enum PensionPageType: String, CaseIterable, Identifiable {
    case detail = "지난 회차"
    case statistics = "통계"
    
    var id: String { rawValue }
}

enum PensionStatisticsType: String, CaseIterable, Identifiable {
    case color = "출현 비율"
    case combination = "번호 조합"
    
    var id: String { rawValue }
}
