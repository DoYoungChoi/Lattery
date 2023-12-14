//
//  Color+Extension.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import SwiftUI


extension Color {
    static let primaryColor = Color("primaryColor")
//    static let backgroundGray = Color("backgroundGray")
    static let pureBackground = Color(uiColor: .systemBackground)
    
//    static let customRed = Color("customRed")
//    static let customPink = Color("customPink")
//    static let customOrange = Color("customOrange")
//    static let customYellow = Color("customYellow")
//    static let customGreen = Color("customGreen")
//    static let customLightBlue = Color("customLightBlue")
//    static let customBlue = Color("customBlue")
//    static let customPurple = Color("customPurple")
//    static let customDarkGray = Color("customDarkGray")
//    
//    static let gray1 = Color("gray1")
//    static let gray2 = Color("gray2")
//    static let gray3 = Color("gray3")
}

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
