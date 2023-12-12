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
}

class Service: ServiceProtocol & ObservableObject {
    var lottoService: LottoServiceProtocol
    var pensionService: PensionServiceProtocol
    
    init(
        lottoService: LottoServiceProtocol,
        pensionService: PensionServiceProtocol
    ) {
        self.lottoService = lottoService
        self.pensionService = pensionService
    }
}

class StubService: ServiceProtocol {
    var lottoService: LottoServiceProtocol = StubLottoService()
    var pensionService: PensionServiceProtocol = StubPensionService()
}
