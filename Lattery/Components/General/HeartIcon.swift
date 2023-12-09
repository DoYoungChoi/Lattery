//
//  HeartIcon.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import SwiftUI

struct HeartIcon: View {
    
    let checked: Bool
    let color: Color
    
    init(checked: Bool, 
         color: Color = .customRed) {
        self.checked = checked
        self.color = color
    }
    
    var body: some View {
        Image(checked ? "heart_fill" : "heart")
            .renderingMode(.template)
            .foregroundColor(color)
    }
}

#Preview {
    HStack {
        HeartIcon(checked: false)
        HeartIcon(checked: true)
    }
}
