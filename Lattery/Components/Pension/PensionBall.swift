//
//  PensionBall.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct PensionBall: View {
    
    let position: Int
    let number: Int?
    var fixed: Bool = false
    
    var body: some View {
        ZStack {
            if let number {
                Circle()
                    .stroke(position.pensionColor, lineWidth: 4)
                
                Circle()
                    .stroke(position.pensionColor)
                    .frame(width: 23, height: 23)
                
                Text("\(number)")
                    .foregroundStyle(Color.primaryColor)
                    .font(.system(size: 18))
            } else {
                Circle()
                    .stroke(position.pensionColor, style: StrokeStyle(lineWidth: 2, dash: [5]))
            }
        }
        .background(fixed ? position.pensionColor.opacity(0.2) : Color.pureBackground)
        .clipShape(Circle())
        .frame(width: 30, height: 30)
    }
}

#Preview {
    VStack {
        HStack {
            ForEach(0..<7, id:\.self) { position in
                PensionBall(position: position, number: nil)
            }
        }
        
        HStack {
            ForEach(0..<7, id:\.self) { position in
                PensionBall(position: position, number: position)
            }
        }
    }
    .padding()
    .background(Color.backgroundGray)
}
