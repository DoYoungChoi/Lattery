//
//  Service.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import Foundation

protocol ServiceProtocol {
    var lottoService: LottoServiceProtocol { get set }
    var pensionService: PensionServiceProtocol { get set }
    var notificationService: NotificationServiceProtocol { get set }
}

class Service: ServiceProtocol & ObservableObject {
    var lottoService: LottoServiceProtocol
    var pensionService: PensionServiceProtocol
    var notificationService: NotificationServiceProtocol
    
    init(
        lottoService: LottoServiceProtocol = LottoService(),
        pensionService: PensionServiceProtocol = PensionService(),
        notificationService: NotificationServiceProtocol = NotificationService()
    ) {
        self.lottoService = lottoService
        self.pensionService = pensionService
        self.notificationService = notificationService
    }
}

class StubService: ServiceProtocol & ObservableObject {
    var lottoService: LottoServiceProtocol = StubLottoService()
    var pensionService: PensionServiceProtocol = StubPensionService()
    var notificationService: NotificationServiceProtocol = StubNotificationService()
}
