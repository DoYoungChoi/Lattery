//
//  BackgroundView.swift
//  Lattery
//
//  Created by dodor on 2023/07/04.
//

import SwiftUI

struct Stone: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.maxX/4, y: rect.maxY/8))
        
        path.addQuadCurve(to: CGPoint(x: rect.maxX*0.9, y: rect.maxY/3),
                          control: CGPoint(x: rect.maxX*4/5, y: -rect.maxY/4))
        
        path.addQuadCurve(to: CGPoint(x: rect.maxX/4, y: rect.maxY*0.9),
                          control: CGPoint(x: rect.maxX*1.25, y: rect.maxY*1.5))
        
        path.addQuadCurve(to: CGPoint(x: rect.maxX/4, y: rect.maxY/8),
                          control: CGPoint(x: -rect.maxX/3, y: rect.midY))
        
        return path
    }
}

struct BackgroundView: View {
    @State private var isAnimating = false
    private var animation: Animation {
        Animation.linear.repeatForever(autoreverses: false).speed(0.01)
    }
    
    var body: some View {
        ZStack {
            Stone()
                .fill(Color.latteYellow)
                .rotationEffect(Angle(degrees: isAnimating ? 360 + 300 : 300))
                .frame(width: 600, height: 600)
                .offset(x: -100, y: -300)
                .animation(animation, value: isAnimating)
            
            Stone()
                .fill(Color.latteBlue)
                .rotationEffect(Angle(degrees: isAnimating ? 360 + 200 : 200))
                .offset(x: 200, y: -200)
                .frame(width: 600, height: 600)
                .animation(animation, value: isAnimating)
            
            Stone()
                .fill(Color.latteRed)
                .rotationEffect(Angle(degrees: isAnimating ? 360 + 120 : 120))
                .offset(x: -200, y: 100)
                .frame(width: 600, height: 600)
                .animation(animation, value: isAnimating)
            
            Stone()
                .fill(Color.latteGreen)
                .rotationEffect(Angle(degrees: isAnimating ? 360 + 30 : 30))
                .offset(x: 250, y: 100)
                .frame(width: 600, height: 600)
                .animation(animation, value: isAnimating)
            
            Stone()
                .fill(Color.latteGray)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .offset(x: 0, y: 500)
                .frame(width: 600, height: 600)
                .animation(animation, value: isAnimating)
        }
        .onAppear {
            isAnimating.toggle()
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
