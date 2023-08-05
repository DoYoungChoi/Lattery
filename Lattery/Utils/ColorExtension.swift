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
    static let backgroundGray = Color("BackgroundGray")
    
    static let customRed = Color("Red")
    static let customOrange = Color("Orange")
    static let customYellow = Color("Yellow")
    static let customGreen = Color("Green")
    static let customLightBlue = Color("LightBlue")
    static let customBlue = Color("Blue")
    static let customPurple = Color("Purple")
    static let customPink = Color("Pink")
    static let customGray = Color("Gray")
    static let customDarkGray = Color("DarkGray")
    static let pawBlack = Color("PawBlack")
//    static let latteRed = Color(hex: "#fd4b4b")
//    static let latteOrange = Color(hex: "#ff8e4e")
//    static let latteYellow = Color(hex: "#ffd633")
//    static let latteGreen = Color(hex: "#71da71")
//    static let latteLightBlue = Color(hex: "#3dbcff")
//    static let latteBlue = Color(hex: "#809fff")
//    static let lattePurple = Color(hex: "#8d70da")
//    static let lattePink = Color(hex: "#feb2b2")
//    static let latteLightGray = Color(hex: "#F4F4F4")
//    static let latteGray = Color(hex: "#C4C4C4")
//    static let latteDarkGray = Color(hex: "#737373")
    
    static let latteIvory = Color("LatteIvory")
    static let latteBrown = Color("LatteBrown")
}

public struct ColorBlended: ViewModifier {
  fileprivate var color: Color
  
  public func body(content: Content) -> some View {
    VStack {
      ZStack {
        content
        color.blendMode(.sourceAtop)
      }
      .drawingGroup(opaque: false)
    }
  }
}

extension View {
  public func blending(color: Color) -> some View {
    modifier(ColorBlended(color: color))
  }
}
