//
//  Pension720.swift
//  Lattery
//
//  Created by dodor on 2023/07/15.
//

import Foundation

struct Pension: Codable, Identifiable {
    var id: UUID { UUID() }
    var rows1: [PensionRow]
    var rows2: [PensionRow]
    var rows: [PensionRow]
}

struct PensionRow: Codable {
    var round: String
    var rank: String?
    var drawDate: String
    var rankClass: String
    var rankNo: String
    var pensionDrawDate: String
}
