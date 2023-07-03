//
//  ColorExtension.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import SwiftUI

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}

extension Color {
    static let latteYellow = Color(hex: "#ffd633")
    static let latteBlue = Color(hex: "#809fff")
    static let latteRed = Color(hex: "#ff704d")
    static let latteGray = Color(hex: "#737373")
    static let latteGreen = Color(hex: "#71da71")
}
