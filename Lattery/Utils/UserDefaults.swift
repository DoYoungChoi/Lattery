//
//  UserDefaults.swift
//  Lattery
//
//  Created by dodor on 2023/08/01.
//

import Foundation

// MARK: - LOTTO
let lastestLottoKey: String = "Lotto"
let favoritesLottoKey: String = "LottoFavorites"
let lottoNotiKey: String = "LottoNoti"

// MARK: - Pension720
let lastestPensionKey: String = "Pension"
let pensionNotiKey: String = "PensionNoti"

// MARK: - Structure
struct Lastest: Identifiable, Codable {
    var id: String
    var round: Int
    var date: Date?
}
