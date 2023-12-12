//
//  LotteryEndpoint.swift
//  Lattery
//
//  Created by dodor on 12/8/23.
//

import Foundation

enum LotteryEndpoint: APIEndpoint {
    
    case getLotto(Int)
    case getPension(Int)
    
    var baseURL: String { "https://dhlottery.co.kr" }
    
    var path: String { "/common.do" }
    
    var method: HTTPMethod { .get }
    
    var headers: [String : String]? { nil }
    
    var parameters: [String : Any]? {
        switch self {
        case .getLotto(let round):
            return ["method": "getLottoNumber", "drwNo": round]
        case .getPension(let round):
            return ["method": "get720Number", "drwNo": round]
        }
    }
}
