//
//  LoadingView.swift
//  Lattery
//
//  Created by dodor on 2023/08/01.
//

import SwiftUI

struct LoadingView: View {
    var text: String
    @State private var index: Int = 0
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.customPink
                .opacity(0.4)
            
            VStack {
                HStack {
                    bouncingBall(color: .customYellow)
                        .offset(y: index == 0 ? -30 : 0)
                    bouncingBall(color: .customBlue)
                        .offset(y: index == 1 ? -30 : 0)
                    bouncingBall(color: .customRed)
                        .offset(y: index == 2 ? -30 : 0)
                    bouncingBall(color: .customDarkGray)
                        .offset(y: index == 3 ? -30 : 0)
                    bouncingBall(color: .customGreen)
                        .offset(y: index == 4 ? -30 : 0)
                }
                
                Text(text)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .padding(.top, 50)
            .padding()
            .background(Color.customPink)
            .cornerRadius(20)
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

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(text: "헤헤")
    }
}
