//
//  String+Extension.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import Foundation

extension String {
    var toLottoDate: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)?.addingTimeInterval(20 * 60 * 60 + 40 * 60)
    }
    
    var toPensionDate: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)?.addingTimeInterval(19 * 60 * 60 + 5 * 60)
    }
    
    var toLottoNumbers: [Int] {
        self.split(separator: ",")
            .map { Int($0) }
            .filter { $0 != nil }
            .map { $0! }
    }
}
