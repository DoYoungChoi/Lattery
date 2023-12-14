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

    var toDateTimeKor: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yy년MM월dd일 HH시mm분 (EEE)"
        return formatter.string(from: self)
    }
    
    var toDateStringKor: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self)
    }
    
    var toTimeKor: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "a h시 m분"
        return formatter.string(from: self)
    }
    
    static func on(year: Int = 2001, month: Int = 1, day: Int = 1,
                   hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date {
        let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        let date = Calendar.current.date(from: dateComponents)!
        return date
    }
    
    var hour: Int {
        let calendar = Calendar(identifier: .gregorian)
        let hour = calendar.component(.hour, from: self)
        return hour
    }
    
    var minute: Int {
        let calendar = Calendar(identifier: .gregorian)
        let minute = calendar.component(.minute, from: self)
        return minute
    }
}
