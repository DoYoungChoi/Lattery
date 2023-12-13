//
//  PensionDrawingLotResult.swift
//  Lattery
//
//  Created by dodor on 12/9/23.
//

import Foundation

struct PensionDrawingLotResult: Hashable {
    let id: String
    let date: Date
    let numbers: [PensionNumbers]
}
