//
//  ServiceError.swift
//  Lattery
//
//  Created by dodor on 12/10/23.
//

import Foundation

enum ServiceError: Error {
    case error(Error)
    case noData
    case unknown
}
