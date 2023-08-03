//
//  FetchingView.swift
//  Lattery
//
//  Created by dodor on 2023/08/01.
//

import SwiftUI

struct FetchingView: View {
    @State private var index: Int = 0
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
            
            BackgroundView()
                .opacity(0.3)
            
            VStack {
                HStack {
                    bouncingBall(color: .latteYellow)
                        .offset(y: index == 0 ? -30 : 0)
                    bouncingBall(color: .latteBlue)
                        .offset(y: index == 1 ? -30 : 0)
                    bouncingBall(color: .latteRed)
                        .offset(y: index == 2 ? -30 : 0)
                    bouncingBall(color: .latteGray)
                        .offset(y: index == 3 ? -30 : 0)
                    bouncingBall(color: .latteGreen)
                        .offset(y: index == 4 ? -30 : 0)
                }
                
                Text("데이터를 가져오는 중입니다")
            }
            .padding()
            .padding(.top, 50)
        }
        .ignoresSafeArea()
        .onReceive(timer) { _ in
            withAnimation {
                index += 1
                if index > 4 { index = 0 }
            }
        }
    }
    
    private struct bouncingBall: View {
        var color: Color
        var body: some View {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
        }
    }
}

struct FetchingView_Previews: PreviewProvider {
    static var previews: some View {
        FetchingView()
    }
}
