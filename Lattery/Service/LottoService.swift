//
//  LottoService.swift
//  Lattery
//
//  Created by dodor on 12/8/23.
//

import Foundation

protocol LottoServiceProtocol {
    func fetchData() async throws -> [LottoResultObject]
    func getData(round: Int) async throws -> LottoResultObject
}

class LottoService: LottoServiceProtocol {

    let apiClient = APIClient<LotteryEndpoint>()
    
    func fetchData() async throws -> [LottoResultObject] {
        let lottoObject: LottoResultObject = try await apiClient.request(.getLotto(1))
        return [lottoObject]
    }
    
    func getData(round: Int) async throws -> LottoResultObject {
        let lottoObject: LottoResultObject = try await apiClient.request(.getLotto(round))
        return lottoObject
    }
}

class StubLottoService: LottoServiceProtocol {
    func fetchData() async throws -> [LottoResultObject] {
        []
    }
    
    func getData(round: Int) async throws -> LottoResultObject {
        LottoResultObject(returnValue: "success")
    }
}
