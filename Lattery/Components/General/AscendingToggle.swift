//
//  AscendingToggle.swift
//  Lattery
//
//  Created by dodor on 12/6/23.
//

import SwiftUI

struct AscendingToggle: View {
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(Color.gray1)
                .frame(width: 3)
            Toggle("회차 오름차순", isOn: $isOn)
                .tint(.accentColor)
        }
    }
}

#Preview {
    VStack {
        AscendingToggle(isOn: .constant(false))
        AscendingToggle(isOn: .constant(true))
    }
}
