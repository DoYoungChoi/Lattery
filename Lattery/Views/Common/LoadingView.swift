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
            Color.customGray
            
            VStack(spacing: 10) {
                ProgressView()
                Text("Loading")
            }
            .foregroundColor(Color(uiColor: .systemBackground))
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
