//
//  NotificationManager.swift
//  Lattery
//
//  Created by dodor on 2023/08/14.
//

import Foundation
import NotificationCenter

class NotificationManager: ObservableObject {
    private let notiCenter = UNUserNotificationCenter.current()
    enum Noti: String, Identifiable {
        var id: String { rawValue }
        case lottoOnAir = "LOTTO_ONAIR_NOTI"
        case lottoBuy = "LOTTO_BUY_NOTI"
        case pensionOnAir = "PENSION_ONAIR_NOTI"
        case pensionBuy = "PENSION_BUY_NOTI"
    }
    
    @Published var showAlert: Bool = false
    @Published var showBuyDaySheet: Bool = false
    @Published var targetNoti: Noti? = nil
    
    // MARK: - Lotto 관련 Property
    @Published var lottoNotiOn: Bool = UserDefaults.standard.bool(forKey: lottoNotiKey) {
        didSet {
            UserDefaults.standard.set(lottoNotiOn, forKey: lottoNotiKey)
            if lottoNotiOn {
                lottoOnAirNotiOn = lottoNotiOn
                lottoBuyNotiOn = lottoNotiOn
            }
        }
    }
    @Published var lottoOnAirNotiOn: Bool = UserDefaults.standard.bool(forKey: lottoOnAirNotiKey) {
        didSet {
            UserDefaults.standard.set(lottoOnAirNotiOn, forKey: lottoOnAirNotiKey)
            if lottoOnAirNotiOn { addLottoOnAirNoti() }
            else { removeLottoOnAirNoti() }
            
            if lottoNotiOn && !lottoOnAirNotiOn && !lottoBuyNotiOn { lottoNotiOn = false }
        }
    }
    @Published var lottoBuyNotiOn: Bool = UserDefaults.standard.bool(forKey: lottoBuyNotiKey) {
        didSet {
            UserDefaults.standard.set(lottoBuyNotiOn, forKey: lottoBuyNotiKey)
            if lottoBuyNotiOn { addLottoBuyNoti() }
            else { removeLottoBuyNoti() }
            
            if lottoNotiOn && !lottoOnAirNotiOn && !lottoBuyNotiOn { lottoNotiOn = false }
        }
    }
    @Published var lottoBuyTime: Date = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: lottoBuyTimeKey))
    @Published var lottoBuyDay: [Int] = (UserDefaults.standard.array(forKey: lottoBuyDaysKey) as? [Int]) ?? [6]
    
    // MARK: - Pension 관련 Property
    @Published var pensionNotiOn: Bool = UserDefaults.standard.bool(forKey: pensionNotiKey) {
        didSet {
            UserDefaults.standard.set(pensionNotiOn, forKey: pensionNotiKey)
            if pensionNotiOn {
                pensionOnAirNotiOn = pensionNotiOn
                pensionBuyNotiOn = pensionNotiOn
            }
        }
    }
    @Published var pensionOnAirNotiOn: Bool = UserDefaults.standard.bool(forKey: pensionOnAirNotiKey) {
        didSet {
            UserDefaults.standard.set(pensionOnAirNotiOn, forKey: pensionOnAirNotiKey)
            if pensionOnAirNotiOn { addPensionOnAirNoti() }
            else { removePensionOnAirNoti() }
            
            if pensionNotiOn && !pensionOnAirNotiOn && !pensionBuyNotiOn { pensionNotiOn = false }
        }
    }
    @Published var pensionBuyNotiOn: Bool = UserDefaults.standard.bool(forKey: pensionBuyNotiKey) {
        didSet {
            UserDefaults.standard.set(pensionBuyNotiOn, forKey: pensionBuyNotiKey)
            if pensionBuyNotiOn { addPensionBuyNoti() }
            else { removePensionBuyNoti() }
            
            if pensionNotiOn && !pensionOnAirNotiOn && !pensionBuyNotiOn { pensionNotiOn = false }
        }
    }
    @Published var pensionBuyTime: Date = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: pensionBuyTimeKey))
    @Published var pensionBuyDay: [Int] = (UserDefaults.standard.array(forKey: pensionBuyDaysKey) as? [Int]) ?? [4]
    
    func initiateNotiAuthorization() {
        notiCenter.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            Task { @MainActor in
                self.initLottoNoti(granted: granted)
                self.initPensionNoti(granted: granted)
            }
        }
    }
    
    private func initLottoNoti(granted: Bool) {
        lottoNotiOn = granted
        UserDefaults.standard.set(granted, forKey: lottoNotiKey)
        lottoOnAirNotiOn = granted
        UserDefaults.standard.set(granted, forKey: lottoOnAirNotiKey)
        lottoBuyNotiOn = granted
        UserDefaults.standard.set(granted, forKey: lottoBuyNotiKey)
        lottoBuyTime = setBuyTime(hour: 20, minute: 35, as: lottoBuyTimeKey)
        lottoBuyDay = [6]
        UserDefaults.standard.set(lottoBuyDay, forKey: lottoBuyDaysKey)
    }
    
    private func initPensionNoti(granted: Bool) {
        pensionNotiOn = granted
        UserDefaults.standard.set(granted, forKey: pensionNotiKey)
        pensionOnAirNotiOn = granted
        UserDefaults.standard.set(granted, forKey: pensionOnAirNotiKey)
        pensionBuyNotiOn = granted
        UserDefaults.standard.set(granted, forKey: pensionBuyNotiKey)
        pensionBuyTime = setBuyTime(hour: 19, minute: 5, as: pensionBuyTimeKey)
        pensionBuyDay = [4]
        UserDefaults.standard.set(pensionBuyDay, forKey: pensionBuyDaysKey)
    }
    
    private func setBuyTime(hour: Int, minute: Int, as userDefaultsKey: String) -> Date {
        let dateComponents = DateComponents(year:1970, month: 1, day:1, hour: hour, minute: minute)
        let date = Calendar.current.date(from: dateComponents)!
        UserDefaults.standard.set(date.timeIntervalSince1970, forKey: userDefaultsKey)
        return date
    }
    
    func checkAuthorization() {
        notiCenter.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            // 이미 설정에서 노티 받기 승인되어 있으면, 실제 앱에서 노티를 끄고 켜고 해도 별 문제가 안됨
            // 설정에서 노티 받지 않기로 되어 있는데 앱에서 노티 받기 상태인 경우 알림 띄우기
            if !granted && (self.lottoOnAirNotiOn || self.lottoBuyNotiOn || self.pensionOnAirNotiOn || self.pensionBuyNotiOn) {
                self.showAlert = true
            }
        }
    }
    
    func addLottoOnAirNoti() {
        let content = UNMutableNotificationContent()
        content.title = "로또 방송 시작 알림"
        content.body = "곧 로또 추첨방송이 시작합니다! 당첨을 기원합니다💘"
        content.sound = UNNotificationSound.default
//        content.badge = 1

        let dateComponents = DateComponents(hour: 20, minute: 35, weekday: 7)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: Noti.lottoOnAir.rawValue, content: content, trigger: trigger)
        notiCenter.add(request)
    }
    
    func addLottoBuyNoti() {
        let content = UNMutableNotificationContent()
        content.title = "로또 구매 알림"
        content.body = "로또 구매할 시간입니다. 이번엔 무조건 당첨!!"
        content.sound = UNNotificationSound.default

        for buyDay in lottoBuyDay {
            let dateComponents = DateComponents(hour: lottoBuyTime.hour, minute: lottoBuyTime.minute, weekday: buyDay)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "\(Noti.lottoBuy.rawValue)_\(buyDay)", content: content, trigger: trigger)
            notiCenter.add(request)
//            print("add: \(Noti.lottoBuy.rawValue)_\(buyDay)")
        }
    }
    
    func addPensionOnAirNoti() {
        let content = UNMutableNotificationContent()
        content.title = "연금복권 방송 시작 알림"
        content.body = "곧 연금복권 추첨방송이 시작합니다! 당첨을 기원합니다💘"
        content.sound = UNNotificationSound.default
        
        let dateComponents = DateComponents(hour: 19, minute: 5, weekday: 5)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: Noti.pensionOnAir.rawValue, content: content, trigger: trigger)
        notiCenter.add(request)
    }
    
    func addPensionBuyNoti() {
        let content = UNMutableNotificationContent()
        content.title = "연금복권 구매 알림"
        content.body = "연금복권 구매할 시간입니다. 이번엔 무조건 당첨!!"
        content.sound = UNNotificationSound.default
        
        for buyDay in pensionBuyDay {
            let dateComponents = DateComponents(hour: pensionBuyTime.hour, minute: pensionBuyTime.minute, weekday: buyDay)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "\(Noti.pensionBuy.rawValue)_\(buyDay)", content: content, trigger: trigger)
            notiCenter.add(request)
//            print("add: \(Noti.pensionBuy.rawValue)_\(buyDay)")
        }
    }
    
    
    // MARK: - 노티 해제
    func removeAllNoti() {
        notiCenter.removeAllDeliveredNotifications()
        notiCenter.removeAllPendingNotificationRequests()
    }
    
    func removeLottoNoti() {
        removeLottoOnAirNoti()
        removeLottoBuyNoti()
    }
    
    func removeLottoOnAirNoti() {
        notiCenter.removeDeliveredNotifications(withIdentifiers: [Noti.lottoOnAir.rawValue])
        notiCenter.removePendingNotificationRequests(withIdentifiers: [Noti.lottoOnAir.rawValue])
    }
    
    func removeLottoBuyNoti() {
        let notis = Array(1...7).map { "\(Noti.lottoBuy.rawValue)_\($0)" }
        notiCenter.removeDeliveredNotifications(withIdentifiers: notis)
        notiCenter.removePendingNotificationRequests(withIdentifiers: notis)
//        print("remove: \(notis)")
    }
    
    func removePensionNoti() {
        removePensionOnAirNoti()
        removePensionBuyNoti()
    }
    
    func removePensionOnAirNoti() {
        notiCenter.removeDeliveredNotifications(withIdentifiers: [Noti.pensionOnAir.rawValue])
        notiCenter.removePendingNotificationRequests(withIdentifiers: [Noti.pensionOnAir.rawValue])
    }
    
    func removePensionBuyNoti() {
        let notis = Array(1...7).map { "\(Noti.pensionBuy.rawValue)_\($0)" }
        notiCenter.removeDeliveredNotifications(withIdentifiers: notis)
        notiCenter.removePendingNotificationRequests(withIdentifiers: notis)
//        print("remove: \(notis)")
    }
    
    // MARK: - 구매 알림 노티 변경
    func changeLottoBuyNoti() {
        _ = setBuyTime(hour: lottoBuyTime.hour, minute: lottoBuyTime.minute, as: lottoBuyTimeKey)
        UserDefaults.standard.set(lottoBuyDay, forKey: lottoBuyDaysKey)
        removeLottoBuyNoti()
        addLottoBuyNoti()
    }
    
    func changePensionBuyNoti() {
        _ = setBuyTime(hour: pensionBuyTime.hour, minute: pensionBuyTime.minute, as: pensionBuyTimeKey)
        UserDefaults.standard.set(pensionBuyDay, forKey: pensionBuyDaysKey)
        removePensionBuyNoti()
        addPensionBuyNoti()
    }
}
