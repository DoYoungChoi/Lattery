//
//  LoadingView.swift
//  Lattery
//
//  Created by dodor on 12/6/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.primaryColor.opacity(0.3)
            
            VStack {
                ProgressView()
                Text("loading...")
            }
            .foregroundStyle(Color.pureBackground)
            .clipShape(Rectangle())
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LoadingView()
}
