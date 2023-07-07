//
//  DateExtension.swift
//  Lattery
//
//  Created by dodor on 2023/07/07.
//

import Foundation

extension Date {
    var toDateStringKor: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self)
    }
}
