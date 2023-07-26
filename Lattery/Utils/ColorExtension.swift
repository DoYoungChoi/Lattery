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
    static let latteRed = Color(hex: "#fd4b4b")
    static let latteOrange = Color(hex: "#ff8e4e")
    static let latteYellow = Color(hex: "#ffd633")
    static let latteLightBlue = Color(hex: "#3dbcff")
    static let latteGreen = Color(hex: "#71da71")
    static let latteBlue = Color(hex: "#809fff")
    static let lattePink = Color(hex: "#feb2b2")
    static let lattePurple = Color(hex: "#8d70da")
    static let latteLightGray = Color(hex: "#c4c4c4")
    static let latteGray = Color(hex: "#737373")
    
    static let latteIvory = Color("LatteIvory")
    static let latteBrown = Color("LatteBrown")
}
