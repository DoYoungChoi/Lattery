//
//  APIError.swift
//  Lattery
//
//  Created by dodor on 12/11/23.
//

import Foundation

enum APIError: String, Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
