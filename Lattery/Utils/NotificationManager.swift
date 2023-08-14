//
//  NotificationManager.swift
//  Lattery
//
//  Created by dodor on 2023/08/14.
//

import Foundation
import NotificationCenter

class NotificationManager: ObservableObject {
    let notiCenter = UNUserNotificationCenter.current()
    enum Noti: String, Identifiable {
        var id: String { rawValue }
        case lotto = "LOTTO_NOTI"
        case pension = "PENSION_NOTI"
    }
    
    @Published var lottoNotiOn: Bool = UserDefaults.standard.bool(forKey: lottoNotiKey) {
        didSet {
            if lottoNotiOn {
                UserDefaults.standard.set(true, forKey: lottoNotiKey)
                addLottoNoti()
            } else {
                UserDefaults.standard.set(false, forKey: lottoNotiKey)
                removeLottoNoti()
            }
        }
    }
    
    @Published var pensionNotiOn: Bool = UserDefaults.standard.bool(forKey: pensionNotiKey) {
        didSet {
            if pensionNotiOn {
                UserDefaults.standard.set(true, forKey: pensionNotiKey)
                addPensionNoti()
            } else {
                UserDefaults.standard.set(false, forKey: pensionNotiKey)
                removePensionNoti()
            }
        }
    }
    
    func requestNotiAuthorization() {
        // 노티 설정 가져오기
        // 상태에 따라 다른 액션 수행
        notiCenter.getNotificationSettings { settings in
            if settings.authorizationStatus != .authorized {
//                self.notiCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                self.notiCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
                    if let error = error {
                        print("Error:\(error.localizedDescription)")
                        return
                    }
                    
                    if granted { // Noti 최초 승인
                        Task { @MainActor in
                            print("최초 승인")
                            self.lottoNotiOn = true
                            self.pensionNotiOn = true
                        }
                    } else { // Noti 최초 거부
                        Task { @MainActor in
                            print("최초 거부")
                            self.lottoNotiOn = false
                            self.pensionNotiOn = false
                        }
                    }
                }
            } else {
                // 노티 승인 상태지만 모든 알림이 off 상태라면 둘 다 on 상태로 바꿈
                if !self.lottoNotiOn && !self.pensionNotiOn {
                    Task { @MainActor in
                        self.lottoNotiOn = true
                        self.pensionNotiOn = true
                    }
                }
            }
            
            // 거부되어 있는 경우
            if settings.authorizationStatus == .denied {
                Task { @MainActor in
                    self.lottoNotiOn = false
                    self.pensionNotiOn = false
                }
            }
        }
    }
    
    func addLottoNoti() {
        let content = UNMutableNotificationContent()

        content.title = "로또 추첨방송 시작 알림"
        content.body = "곧 로또 추첨방송이 시작할 예정입니다. 당첨을 기원합니다!"
        content.sound = UNNotificationSound.default
//        content.badge = 1

        let dateComponents = DateComponents(hour: 20, minute: 35, weekday: 7)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: Noti.lotto.rawValue, content: content, trigger: trigger)

        notiCenter.add(request)
    }
    
    func addPensionNoti() {
        let content = UNMutableNotificationContent()

        content.title = "연금복권 추첨방송 시작 알림"
        content.body = "곧 연금복권 추첨방송이 시작할 예정입니다. 당첨을 기원합니다!"
        content.sound = UNNotificationSound.default
//        content.badge = 1
        
        let dateComponents = DateComponents(hour: 19, minute: 5, weekday: 5)
//        let dateComponents = DateComponents(hour: 1, minute: 26, weekday: 3)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: Noti.pension.rawValue, content: content, trigger: trigger)

        notiCenter.add(request)
    }
    
    func removeAllNoti() {
        notiCenter.removeAllDeliveredNotifications()
        notiCenter.removeAllPendingNotificationRequests()
    }
    
    func removeLottoNoti() {
        notiCenter.removeDeliveredNotifications(withIdentifiers: [Noti.lotto.rawValue])
        notiCenter.removePendingNotificationRequests(withIdentifiers: [Noti.lotto.rawValue])
    }
    
    func removePensionNoti() {
        notiCenter.removeDeliveredNotifications(withIdentifiers: [Noti.pension.rawValue])
        notiCenter.removePendingNotificationRequests(withIdentifiers: [Noti.pension.rawValue])
    }
}
