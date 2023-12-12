//
//  Constant.swift
//  Lattery
//
//  Created by dodor on 12/11/23.
//

import Foundation

typealias AppStorageKey = Constant.AppStorage

enum Constant { }

extension Constant {
    struct AppStorage {
        static let lottoRound = "AppStorage_LottoRound"
        static let lottoDate = "AppStorage_LottoDate"
        static let pensionRound = "AppStorage_PensionRound"
        static let pensionDate = "AppStorage_PensionDate"
    }
}
