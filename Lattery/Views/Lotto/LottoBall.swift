//
//  LottoBall.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import SwiftUI

struct LottoBall: View {
    var number: Int? = nil
    @ScaledMetric var basic = 20
    
    var body: some View {
        if let number = number, Range(1...45).contains(number) {
            ZStack {
                Circle()
                    .foregroundColor(number <= 10 ? .latteYellow
                                     : number <= 20 ? .latteBlue
                                     : number <= 30 ? .latteRed
                                     : number <= 40 ? .latteGray
                                     : .latteGreen)
                    .aspectRatio(1, contentMode: .fit)
                
                Text("\(number)")
                    .foregroundColor(.white)
                    .bold()
            }
            .frame(width: basic * 1.8, height: basic * 1.8)
        } else {
            Circle()
                .stroke(Color.secondary, style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(width: basic * 1.8, height: basic * 1.8)
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
                            LottoBall(number: tens * 10 + units)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
