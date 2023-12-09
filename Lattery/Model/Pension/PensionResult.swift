//
//  PensionResult.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import Foundation

struct PensionResult: Identifiable {
    var id: Int { round }
    var round: Int
    var date: Date
    var group: Int
    var numbers: String
    var bonus: String
}
