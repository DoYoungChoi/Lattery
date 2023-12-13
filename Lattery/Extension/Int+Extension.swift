//
//  Int+Extension.swift
//  Lattery
//
//  Created by dodor on 12/6/23.
//

import SwiftUI

extension Int {
    var lottoColor: Color {
        if self > 0 && self < 11 { return .customYellow }
        else if self > 10 && self < 21 { return .customBlue }
        else if self > 20 && self < 31 { return .customRed }
        else if self > 30 && self < 41 { return .customDarkGray }
        else if self > 40 && self < 46 { return .customGreen }
        else { return .gray1 }
    }
    
    var pensionColor : Color {
        if self == 0 { return .gray2 }
        else if self == 1 { return .customRed }
        else if self == 2 { return .customOrange }
        else if self == 3 { return .customYellow }
        else if self == 4 { return .customLightBlue }
        else if self == 5 { return .customPurple }
        else { return .customDarkGray }
    }
}
