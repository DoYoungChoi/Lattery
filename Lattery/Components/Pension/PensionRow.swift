//
//  PensionRow.swift
//  Lattery
//
//  Created by dodor on 12/6/23.
//

import SwiftUI

struct PensionRow: View {
    
    var numbers: [Int?] = []
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 8) {
            
            if numbers.count == 7 {
                pensionBalls
            } else {
                emptyBalls
            }
            
            if let action {
                Button {
                    action()
                } label: {
                    Image("check_pencil")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.backgroundGray)
        .cornerRadius(10)
    }
    
    var emptyBalls: some View {
        HStack(spacing: 8) {
            ForEach(0..<7, id:\.self) { position in
                PensionBall(position: position,
                            number: nil)
                if position == 0 {
                    Text("조")
                        .font(.subheadline)
                        .foregroundStyle(Color.primaryColor)
                }
            }
        }
    }
    
    var pensionBalls: some View {
        HStack(spacing: 8) {
            ForEach(Array(numbers.enumerated()), id:\.offset) { (position, number) in
                PensionBall(position: position,
                            number: number)
                if position == 0 {
                    Text("조")
                        .font(.subheadline)
                        .foregroundStyle(Color.primaryColor)
                }
            }
        }
    }
}

#Preview {
    PensionRow() { }
}
