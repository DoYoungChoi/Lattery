//
//  LottoBall.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import SwiftUI

struct LottoBall: View {
    var number: Int16? = nil
    var isFixed: Bool = false
    private var color: Color {
        guard let number = number else { return .lattePink }
        
        if number <= 10 {
            return .latteYellow
        } else if number <= 20 {
            return .latteBlue
        } else if number <= 30 {
            return .latteRed
        } else if number <= 40 {
            return .latteGray
        } else {
            return .latteGreen
        }
    }
    
    var body: some View {
        if let number = number, Range(1...45).contains(number) {
            ZStack {
                Circle()
                    .foregroundColor(color)
                    .aspectRatio(1, contentMode: .fit)
                    .shadow(color: color, radius: isFixed ? 10 : 0)
                
                Text("\(number)")
                    .foregroundColor(.white)
                    .bold()
            }
            .font(.system(size: 18))
            .frame(width: 30, height: 30)
        } else {
            Circle()
                .stroke(Color.secondary, style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(width: 30, height: 30)
                .background {
                    Circle()
                        .fill(.background.opacity(0.7))
                }
        }
    }
}

struct LottoBall_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LottoBall(number: 0)
            
            ForEach(0...4, id: \.self) { tens in
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(1...10, id: \.self) { units in
                            LottoBall(number: Int16(tens * 10 + units))
                        }
                    }
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.thinMaterial)
        }
    }
}
