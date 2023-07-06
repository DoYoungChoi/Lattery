//
//  LoadingView.swift
//  Lattery
//
//  Created by dodor on 2023/07/06.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.primary.opacity(0.2)
            
            VStack(spacing: 10) {
                ProgressView()
                Text("Loading")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
