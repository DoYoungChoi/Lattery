//
//  APIClient.swift
//  Lattery
//
//  Created by dodor on 12/8/23.
//

import Foundation

protocol APIClientProtocol {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> T
}

class APIClient<EndpointType: APIEndpoint>: APIClientProtocol {
    func request<T>(_ endpoint: EndpointType) async throws -> T where T : Decodable {
        var urlString = endpoint.baseURL + endpoint.path
        if let parameters = endpoint.parameters {
            urlString += "?"
            parameters.forEach { urlString += "\($0.key)=\($0.value)" }
        }

        guard let url = URL(string: urlString) else { throw APIError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode else { throw APIError.invalidResponse}
        
        guard let dataObject = try? JSONDecoder().decode(T.self, from: data) else { throw APIError.invalidData }
        
        return dataObject
    }
}



