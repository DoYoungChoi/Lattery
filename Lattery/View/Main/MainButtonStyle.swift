//
//  MainButtonStyle.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import SwiftUI

struct MainButtonStyle: ButtonStyle {
    
    let imageName: String
    
    func makeBody(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.pureBackground)
            .shadow(color: .gray1, radius: 5)
            .overlay {
                VStack {
                    Image(imageName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .foregroundColor(.accentColor)
                    configuration.label
                        .font(.body)
                }
            }
    }
}
