//
//  LottoNumberSheetButtonStyle.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.accentColor)
            .frame(minHeight: 30, maxHeight: 50)
            .overlay {
                configuration.label
                    .font(.body)
                    .foregroundColor(.white)
            }
    }
}

struct CustomFitButtonStyle: ButtonStyle {
    
    let isSelected: Bool
    let color: Color
    
    init(isSelected: Bool,
         color: Color = .accentColor) {
        self.isSelected = isSelected
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body)
            .foregroundColor(isSelected ? .pureBackground : color)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color)
            }
            .background(isSelected ? color : Color.pureBackground)
            .cornerRadius(10)
    }
}
