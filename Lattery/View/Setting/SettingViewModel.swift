//
//  SettingViewModel.swift
//  Lattery
//
//  Created by dodor on 12/14/23.
//

import Foundation
import SwiftUI

@MainActor
class SettingViewModel: ObservableObject {
    
    enum Action {
        case checkNotiAuthorization
        case showAlert
        case tapAlertCheckButton
        case tapAlertMoveButton
        case toggleBuyDaysSheet(LotteryType)
        case saveBuyDayTime([Int], Date)
        
        case fetch(LotteryType)
        
        case openLottoDrawingLotResult
        case deleteLottoDrawingLotResult(String)
        
        case openLottoFavorites
        case toggleLottoNumberSheet
        case addLottoFavorite([Int])
        case deleteLottoFavorite(LottoFavorite)
        
        case openPensionDrawingLotResult
        case deletePensionDrawingLotResult(String)
    }
    
    @Published var showAlert: Bool = false
    @Published var lottoNotiOn: Bool = UserDefaults.standard.bool(forKey: AppStorageKey.lottoNoti) {
        didSet {
            UserDefaults.standard.set(lottoNotiOn, forKey: AppStorageKey.lottoNoti)
            if lottoNotiOn {
                lottoOnAirNotiOn = lottoNotiOn
                lottoBuyNotiOn = lottoNotiOn
            }
        }
    }
    @Published var lottoOnAirNotiOn: Bool = UserDefaults.standard.bool(forKey: AppStorageKey.lottoOnAirNoti) {
        didSet {
            UserDefaults.standard.set(lottoOnAirNotiOn, forKey: AppStorageKey.lottoOnAirNoti)
            if lottoOnAirNotiOn { services.notificationService.addLottoOnAirNoti() }
            else { services.notificationService.removeLottoOnAirNoti() }
            
            if lottoNotiOn && !lottoOnAirNotiOn && !lottoBuyNotiOn { lottoNotiOn = false }
        }
    }
    @Published var lottoBuyNotiOn: Bool = UserDefaults.standard.bool(forKey: AppStorageKey.lottoBuyNoti) {
        didSet {
            UserDefaults.standard.set(lottoBuyNotiOn, forKey: AppStorageKey.lottoBuyNoti)
            if lottoOnAirNotiOn {
                services.notificationService.addLottoBuyNoti(days: self.lottoBuyDays,
                                                             time: self.lottoBuyTime)
            } else {
                services.notificationService.removeLottoBuyNoti()
            }
            
            if lottoNotiOn && !lottoOnAirNotiOn && !lottoBuyNotiOn { lottoNotiOn = false }
        }
    }
    @Published var lottoBuyDays: [Int] = (UserDefaults.standard.array(forKey: AppStorageKey.lottoBuyDays) as? [Int]) ?? [6] {
        didSet {
            UserDefaults.standard.set(lottoBuyDays, forKey: AppStorageKey.lottoBuyDays)
        }
    }
    @Published var lottoBuyTime: Date = Date(timeIntervalSinceReferenceDate: UserDefaults.standard.double(forKey: AppStorageKey.lottoBuyTime)) {
        didSet {
            let time: Date = Date.on(hour: lottoBuyTime.hour, minute: lottoBuyTime.minute)
            UserDefaults.standard.set(time.timeIntervalSinceReferenceDate, forKey: AppStorageKey.lottoBuyTime)
        }
    }
    
    @Published var pensionNotiOn: Bool = UserDefaults.standard.bool(forKey: AppStorageKey.pensionNoti) {
        didSet {
            UserDefaults.standard.set(pensionNotiOn, forKey: AppStorageKey.pensionNoti)
            if pensionNotiOn {
                pensionOnAirNotiOn = pensionNotiOn
                pensionBuyNotiOn = pensionNotiOn
            }
        }
    }
    @Published var pensionOnAirNotiOn: Bool = UserDefaults.standard.bool(forKey: AppStorageKey.pensionOnAirNoti) {
        didSet {
            UserDefaults.standard.set(pensionOnAirNotiOn, forKey: AppStorageKey.pensionOnAirNoti)
            if pensionOnAirNotiOn { services.notificationService.addPensionOnAirNoti() }
            else { services.notificationService.removePensionOnAirNoti() }
            
            if pensionNotiOn && !pensionOnAirNotiOn && !pensionBuyNotiOn { pensionNotiOn = false }
        }
    }
    @Published var pensionBuyNotiOn: Bool = UserDefaults.standard.bool(forKey: AppStorageKey.pensionBuyNoti) {
        didSet {
            UserDefaults.standard.set(pensionBuyNotiOn, forKey: AppStorageKey.pensionBuyNoti)
            if pensionOnAirNotiOn { 
                services.notificationService.addPensionBuyNoti(days: self.pensionBuyDays,
                                                               time: self.pensionBuyTime)
            } else {
                services.notificationService.removePensionBuyNoti()
            }
            
            if pensionNotiOn && !pensionOnAirNotiOn && !pensionBuyNotiOn { pensionNotiOn = false }
        }
    }
    @Published var pensionBuyDays: [Int] = (UserDefaults.standard.array(forKey: AppStorageKey.pensionBuyDays) as? [Int]) ?? [4] {
        didSet {
            UserDefaults.standard.set(pensionBuyDays, forKey: AppStorageKey.pensionBuyDays)
        }
    }
    @Published var pensionBuyTime: Date = Date(timeIntervalSinceReferenceDate: UserDefaults.standard.double(forKey: AppStorageKey.pensionBuyTime)) {
        didSet {
            let time: Date = Date.on(hour: pensionBuyTime.hour, minute: pensionBuyTime.minute)
            UserDefaults.standard.set(time.timeIntervalSinceReferenceDate, forKey: AppStorageKey.pensionBuyTime)
        }
    }
    
    @Published var showBuyDaysSheet: Bool = false
    
    @Published var lotteryType: LotteryType = .lotto
    @Published var phase: Phase = .notRequested {
        didSet {
            if phase == .success { phase = .notRequested }
        }
    }
    
    @Published var lottoDrawingLotResults: [LottoDrawingLotResult] = []
    @Published var pensionDrawingLotResults: [PensionDrawingLotResult] = []
    
    @Published var lottoFavorites: [LottoFavorite] = []
    @Published var showLottoNumberSheet: Bool = false
    
    private var services: ServiceProtocol
    private let weekdays: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    init(services: ServiceProtocol) {
        self.services = services
    }
    
    func send(action: Action) {
        switch action {
        case .checkNotiAuthorization:
            services.notificationService.checkAuthorization { [weak self] granted in
                guard granted == false,
                      let lottoNotiOn = self?.lottoNotiOn,
                      let pensionNotiOn = self?.pensionNotiOn,
                      (lottoNotiOn || pensionNotiOn)
                else { return }
                
                DispatchQueue.main.async {
                    self?.send(action: .showAlert)
                }
            }
        case .showAlert:
            showAlert = true
        case .tapAlertCheckButton:
            showAlert = false
        case .tapAlertMoveButton:
            showAlert = false
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case .toggleBuyDaysSheet(let type):
            lotteryType = type
            showBuyDaysSheet.toggle()
        case let .saveBuyDayTime(days, time):
            if lotteryType == .lotto {
                if days.count < 1 {
                    lottoBuyNotiOn = false
                    showBuyDaysSheet.toggle()
                    return
                }
                lottoBuyDays = days.sorted()
                lottoBuyTime = time
                services.notificationService.removeLottoBuyNoti()
                services.notificationService.addLottoBuyNoti(days: lottoBuyDays,
                                                             time: lottoBuyTime)
            } else {
                if days.count < 1 {
                    pensionBuyNotiOn = false
                    showBuyDaysSheet.toggle()
                    return
                }
                pensionBuyDays = days.sorted()
                pensionBuyTime = time
                services.notificationService.removePensionBuyNoti()
                services.notificationService.addPensionBuyNoti(days: pensionBuyDays,
                                                               time: pensionBuyTime)
            }
            showBuyDaysSheet.toggle()
        case .fetch(let type):
            lotteryType = type
            phase = .loading
        case .openLottoDrawingLotResult:
            lottoDrawingLotResults = services.lottoService.getLottoDrawingLotResults()
        case .deleteLottoDrawingLotResult(let id):
            do {
                try services.lottoService.delete(drawingLotNumbersById: id)
            } catch { print(error.localizedDescription) }
            lottoDrawingLotResults = services.lottoService.getLottoDrawingLotResults()
        case .openLottoFavorites:
            lottoFavorites = services.lottoService.getFavoriteNumbers()
        case .toggleLottoNumberSheet:
            showLottoNumberSheet.toggle()
        case .addLottoFavorite(let numbers):
            do {
                try services.lottoService.add(favoriteNumbers: numbers)
            } catch { print(error.localizedDescription) }
            lottoFavorites = services.lottoService.getFavoriteNumbers()
        case .deleteLottoFavorite(let favorite):
            do {
                if let numbers = favorite.numbers?.toLottoNumbers,
                   !numbers.isEmpty {
                    try services.lottoService.delete(favoriteNumbers: numbers)
                }
            } catch { print(error.localizedDescription) }
            lottoFavorites = services.lottoService.getFavoriteNumbers()
        case .openPensionDrawingLotResult:
            pensionDrawingLotResults = services.pensionService.getPensionDrawingLotResults()
        case .deletePensionDrawingLotResult(let id):
            do {
                try services.pensionService.delete(drawingLotNumbersById: id)
            } catch { print(error.localizedDescription) }
            pensionDrawingLotResults = services.pensionService.getPensionDrawingLotResults()
        }
    }

    func days(for type: LotteryType) -> String {
        if type == .lotto { lottoBuyDays.sorted().map({ weekdays[$0-1] }).joined(separator: " / ") }
        else { pensionBuyDays.sorted().map({ weekdays[$0-1] }).joined(separator: " / ") }
    }
}
