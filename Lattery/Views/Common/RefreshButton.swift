//
//  RefreshButton.swift
//  Lattery
//
//  Created by dodor on 2023/07/16.
//

import SwiftUI

struct RefreshButton: View {
    var action: () -> ()
    @State private var isPressed: Bool = false
    
    var body: some View {
        Button {
            withAnimation {
                isPressed.toggle()
                action()
            }
            isPressed.toggle()
        } label: {
            Label("재시작", systemImage: "arrow.counterclockwise")
                .rotationEffect(Angle(degrees: isPressed ? 0 : 360))
        }
    }
}

struct RefreshButton_Previews: PreviewProvider {
    static var previews: some View {
        RefreshButton() {
            print("refresh")
        }
    }
}
