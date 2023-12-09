//
//  LottoBall.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import SwiftUI

struct LottoBall: View {
    
    let number: Int?
    var fixed: Bool = false

    var body: some View {
        if let number {
            Circle()
                .fill(number.lottoColor)
                .overlay {
                    if fixed {
                        Circle()
                            .stroke(Color.accentColor,
                                    lineWidth: 2)
                    }
                    
                    Text("\(number)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(width: 30, height: 30)
        } else {
            Circle()
                .fill(.background)
                .overlay {
                    Circle()
                        .stroke(Color.gray1,
                                style: StrokeStyle(lineWidth: 2, dash: [5]))
                }
                .frame(width: 30, height: 30)
        }
    }
}


#Preview {
    VStack {
        ForEach(0...4, id: \.self) { tens in
            ScrollView(.horizontal) {
                HStack {
                    ForEach(1...10, id: \.self) { units in
                        if let number = tens * 10 + units as Int?,
                           number < 46 {
                            LottoBall(number: number)
                        } else {
                            LottoBall(number: nil)
                        }
                    }
                }
            }
        }
    }
    .padding()
    .background {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.backgroundGray)
    }
}
