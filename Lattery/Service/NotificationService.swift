//
//  NotificationService.swift
//  Lattery
//
//  Created by dodor on 12/14/23.
//

import Foundation
import NotificationCenter

enum NotiType: String, Identifiable {
    var id: String { rawValue }
    case lottoOnAir = "LOTTO_ONAIR_NOTI"
    case lottoBuy = "LOTTO_BUY_NOTI"
    case pensionOnAir = "PENSION_ONAIR_NOTI"
    case pensionBuy = "PENSION_BUY_NOTI"
}

protocol NotificationServiceProtocol {
    // 전체
    func requestAuthorization()
    func checkAuthorization(completion: @escaping (Bool) -> Void)
    func removeAllNoti()
    
    // Lotto
    func addLottoOnAirNoti()
    func addLottoBuyNoti(days: [Int], time: Date)
    func removeLottoNoti()
    func removeLottoOnAirNoti()
    func removeLottoBuyNoti()
    
    // Pension
    func addPensionOnAirNoti()
    func addPensionBuyNoti(days: [Int], time: Date)
    func removePensionNoti()
    func removePensionOnAirNoti()
    func removePensionBuyNoti()
    
}

class NotificationService: NotificationServiceProtocol {
    
    // MARK: - 전체
    let notiCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
        notiCenter.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            self.initLottoNoti(granted: granted)
            self.initPensionNoti(granted: granted)
        }
    }
    
    func checkAuthorization(completion: @escaping (Bool) -> Void) {
        notiCenter.requestAuthorization { granted, _ in
            completion(granted)
        }
    }
    
    func removeAllNoti() {
        notiCenter.removeAllDeliveredNotifications()
        notiCenter.removeAllPendingNotificationRequests()
    }
    
    // MARK: - Lotto
    private func initLottoNoti(granted: Bool) {
        UserDefaults.standard.set(granted, forKey: AppStorageKey.lottoNoti)
        UserDefaults.standard.set(granted, forKey: AppStorageKey.lottoOnAirNoti)
        UserDefaults.standard.set(granted, forKey: AppStorageKey.lottoBuyNoti)
        let days: [Int] = [6]
        UserDefaults.standard.set(days, forKey: AppStorageKey.lottoBuyDays)
        let time: Date = Date.on(hour: 20, minute: 35)
        UserDefaults.standard.set(time.timeIntervalSinceReferenceDate, forKey: AppStorageKey.lottoBuyTime)
        if granted {
            self.addLottoOnAirNoti()
            self.addLottoBuyNoti(days: days, time: time)
        }
    }
    
    func addLottoOnAirNoti() {
        let content = UNMutableNotificationContent()
        content.title = "로또 방송 시작 알림"
        content.body = "곧 로또 추첨방송이 시작합니다! 당첨을 기원합니다💘"
        content.sound = UNNotificationSound.default
//        content.badge = 1

        let dateComponents = DateComponents(hour: 20, minute: 35, weekday: 7)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: true)
        let request = UNNotificationRequest(identifier: NotiType.lottoOnAir.id,
                                            content: content,
                                            trigger: trigger)
        notiCenter.add(request)
    }
    
    func addLottoBuyNoti(days: [Int], time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "로또 구매 알림"
        content.body = "로또 구매할 시간입니다. 이번엔 무조건 당첨!!"
        content.sound = UNNotificationSound.default

        for day in days {
            let dateComponents = DateComponents(hour: time.hour,
                                                minute: time.minute,
                                                weekday: day)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                        repeats: true)
            let request = UNNotificationRequest(identifier: "\(NotiType.lottoBuy.id)_\(day)",
                                                content: content,
                                                trigger: trigger)
            notiCenter.add(request)
        }
    }
    
    func removeLottoNoti() {
        removeLottoOnAirNoti()
        removeLottoBuyNoti()
    }
    
    func removeLottoOnAirNoti() {
        notiCenter.removeDeliveredNotifications(withIdentifiers: [NotiType.lottoOnAir.id])
        notiCenter.removePendingNotificationRequests(withIdentifiers: [NotiType.lottoOnAir.id])
    }
    
    func removeLottoBuyNoti() {
        let notis = Array(1...7).map { "\(NotiType.lottoBuy.id)_\($0)" }
        notiCenter.removeDeliveredNotifications(withIdentifiers: notis)
        notiCenter.removePendingNotificationRequests(withIdentifiers: notis)
    }
    
    // MARK: - Pension
    private func initPensionNoti(granted: Bool) {
        UserDefaults.standard.set(granted, forKey: AppStorageKey.pensionNoti)
        UserDefaults.standard.set(granted, forKey: AppStorageKey.pensionOnAirNoti)
        UserDefaults.standard.set(granted, forKey: AppStorageKey.pensionBuyNoti)
        let days: [Int] = [4]
        UserDefaults.standard.set(days, forKey: AppStorageKey.pensionBuyDays)
        let time: Date = Date.on(hour: 19, minute: 5)
        UserDefaults.standard.set(time.timeIntervalSinceReferenceDate, forKey: AppStorageKey.pensionBuyTime)
        if granted {
            self.addPensionOnAirNoti()
            self.addPensionBuyNoti(days: days, time: time)
        }
    }
    
    func addPensionOnAirNoti() {
        let content = UNMutableNotificationContent()
        content.title = "연금복권 방송 시작 알림"
        content.body = "곧 연금복권 추첨방송이 시작합니다! 당첨을 기원합니다💘"
        content.sound = UNNotificationSound.default
        
        let dateComponents = DateComponents(hour: 19, minute: 5, weekday: 5)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, 
                                                    repeats: true)
        let request = UNNotificationRequest(identifier: NotiType.pensionOnAir.id,
                                            content: content,
                                            trigger: trigger)
        notiCenter.add(request)
    }
    
    func addPensionBuyNoti(days: [Int], time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "연금복권 구매 알림"
        content.body = "연금복권 구매할 시간입니다. 이번엔 무조건 당첨!!"
        content.sound = UNNotificationSound.default
        
        for day in days {
            let dateComponents = DateComponents(hour: time.hour,
                                                minute: time.minute,
                                                weekday: day)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                        repeats: true)
            let request = UNNotificationRequest(identifier: "\(NotiType.pensionBuy.id)_\(day)",
                                                content: content,
                                                trigger: trigger)
            notiCenter.add(request)
        }
    }
    
    func removePensionNoti() {
        removeLottoOnAirNoti()
        removeLottoBuyNoti()
    }
    
    func removePensionOnAirNoti() {
        notiCenter.removeDeliveredNotifications(withIdentifiers: [NotiType.pensionOnAir.id])
        notiCenter.removePendingNotificationRequests(withIdentifiers: [NotiType.pensionOnAir.id])
    }
    
    func removePensionBuyNoti() {
        let notis = Array(1...7).map { "\(NotiType.pensionBuy.id)_\($0)" }
        notiCenter.removeDeliveredNotifications(withIdentifiers: notis)
        notiCenter.removePendingNotificationRequests(withIdentifiers: notis)
    }
}

class StubNotificationService: NotificationServiceProtocol {
    func requestAuthorization() { }
    func checkAuthorization(completion: @escaping (Bool) -> Void) { }
    func removeAllNoti() { }
    
    func addLottoOnAirNoti() { }
    func addLottoBuyNoti(days: [Int], time: Date) { }
    func removeLottoNoti() { }
    func removeLottoOnAirNoti() { }
    func removeLottoBuyNoti() { }
    
    func addPensionOnAirNoti() { }
    func addPensionBuyNoti(days: [Int], time: Date) { }
    func removePensionNoti() { }
    func removePensionOnAirNoti() { }
    func removePensionBuyNoti() { }
}
