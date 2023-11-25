//
//  UserDefaults.swift
//  Lattery
//
//  Created by dodor on 2023/08/01.
//

import Foundation

let initialOpenKey: String = "InitialOpen"

// MARK: - LOTTO
let lastestLottoKey: String = "Lotto"
let favoritesLottoKey: String = "LottoFavorites"
let lottoNotiKey: String = "LottoNoti"
let lottoOnAirNotiKey: String = "LottoOnAirNoti"
let lottoBuyNotiKey: String = "LottoBuyNoti"
let lottoBuyTimeKey: String = "LottoBuyTime"
let lottoBuyDaysKey: String = "LottoBuyDays"

// MARK: - Pension720
let lastestPensionKey: String = "Pension"
let pensionNotiKey: String = "PensionNoti"
let pensionOnAirNotiKey: String = "PensionOnAirNoti"
let pensionBuyNotiKey: String = "PensionBuyNoti"
let pensionBuyTimeKey: String = "PensionBuyTime"
let pensionBuyDaysKey: String = "PensionBuyDays"

// MARK: - Structure
struct Lastest: Identifiable, Codable {
    var id: String
    var round: Int
    var date: Date?
}
