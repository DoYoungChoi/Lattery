//
//  Date+Extension.swift
//  Lattery
//
//  Created by dodor on 12/6/23.
//

import Foundation

extension Date {
    var toDateTimeString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yyyy/MM/dd (E) HH:mm:ss"
        return formatter.string(from: self)
    }
}
