//
//  PawButton.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import SwiftUI

enum Paw: String, Identifiable, CaseIterable {
    case pink = "삥꾸발바닥"
    case black = "까망발바닥"
    
    var id: String { rawValue }
    var image: Image {
        switch self {
        case .pink:
            return Image("pink_paw_button")
        case .black:
            return Image("black_paw_button")
        }
    }
}

struct PawButton: View {
    
    var type: Paw
    var action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Button(action: action) {
                type.image
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.2)
            }
            Spacer()
        }
    }
}

#Preview {
    PawButton(type: .pink) { }
}
