//
//  PensionData.swift
//  Lattery
//
//  Created by dodor on 2023/07/15.
//

import Foundation

class PensionData: ObservableObject {
    init() { }
    
    func fetchData(_ nth: Int) async throws -> Pension {
        guard let url = URL(string: "https://dhlottery.co.kr/common.do?method=get720Number&drwNo=\(nth)") else { throw FetchError.badURL }
        
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode else { throw FetchError.badRequest }
//        print("\(url) Returned: \(String(data: data, encoding: .utf8) ?? "--")")
        
        guard let pension: Pension = try? JSONDecoder().decode(Pension.self, from: data) else { throw FetchError.badJSON }
        
        return pension
    }
}
