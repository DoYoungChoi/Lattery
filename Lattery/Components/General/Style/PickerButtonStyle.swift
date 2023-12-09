//
//  PickerButtonStyle.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import SwiftUI

struct PickerButtonStyle: ButtonStyle {
    
    let isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Rectangle()
                .fill(.background)
            
            VStack(spacing: 4) {
                HStack {
                    Spacer()
                    configuration.label
                        .font(.body)
                        .foregroundColor(isSelected ? .primaryColor : .gray1)
                    Spacer()
                }
                
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(height: 2)
                    .opacity(isSelected ? 1 : 0)
            }
        }
        .frame(maxHeight: 30)
    }
}
