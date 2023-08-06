//
//  PensionBall.swift
//  Lattery
//
//  Created by dodor on 2023/07/16.
//

import SwiftUI

struct PensionBall: View {
    var number: Int16? = nil
    var unit: Int
    var isFixed: Bool = false
    private var color: Color {
        guard unit > 0 && unit < 7 else { return .customGray }
        
        if unit == 1 {
            return .customRed
        } else if unit == 2 {
            return .customOrange
        } else if unit == 3 {
            return .customYellow
        } else if unit == 4 {
            return .customLightBlue
        } else if unit == 5 {
            return .customPurple
        } else if unit == 6 {
            return .customDarkGray
        } else {
            return .customGray
        }
    }
   
    var body: some View {
        if let number = number, Range(0...9).contains(number) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 2)
                    .shadow(color: color, radius: isFixed ? 10 : 0)
                
                Circle()
                    .stroke(lineWidth: 1)
                    .frame(width: 25, height: 25)
                
                Text("\(number)")
                    .foregroundColor(.primary)
                    .bold()
            }
            .foregroundColor(color)
            .font(.system(size: 18))
            .frame(width: 30, height: 30)
            .background {
                Circle()
                    .fill(.background)
            }
        } else {
            Circle()
                .stroke(color, style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(width: 30, height: 30)
                .background {
                    Circle()
                        .fill(.background.opacity(0.7))
                }
        }
    }
}

struct PensionBall_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ForEach(0..<10, id:\.self) { row in
                HStack {
                    ForEach(0..<7, id:\.self) { col in
                        PensionBall(number: Int16(row), unit: col)
                    }
                }
            }
        }
    }
}
