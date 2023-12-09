//
//  PensionEntity.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import Foundation

struct PensionEntity: Identifiable, Hashable {
    var id: Int16 { round }
    var round: Int16
    var date: Date
    var group: Int16
    var numbers: String
    var bonus: String
}
