//
//  String+Extension.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import Foundation

extension String {
    var toDate: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }
}
