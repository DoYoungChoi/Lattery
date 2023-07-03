//
//  WinNumberFetcher.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import Foundation

class WinNumberFetcher: ObservableObject {
    @Published private var winNumber: [Int: [Int]] = [:]
}
