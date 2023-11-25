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
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self)
    }
    
    var toDateStringSlash: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: self)
    }
    
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
    
    var toTimeKor: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "a h시 m분"
        return formatter.string(from: self)
    }
    
    var nextSatureday: Date {
        let calendar = Calendar(identifier: .gregorian)
        let dayOfWeek = calendar.component(.weekday, from: self)
        return Date(timeIntervalSinceNow: 60*60*24*(7-Double(dayOfWeek)))
    }
    
    var nextThursday: Date {
        let calendar = Calendar(identifier: .gregorian)
        let dayOfWeek = calendar.component(.weekday, from: self)
        let dayDiff = dayOfWeek > 5 ? 7 : 0
        return Date(timeIntervalSinceNow: 60*60*24*(5-Double(dayOfWeek+dayDiff)))
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
