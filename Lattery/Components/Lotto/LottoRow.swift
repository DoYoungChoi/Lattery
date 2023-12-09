//
//  LottoRow.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import SwiftUI

struct LottoRow: View {
    
    var group: LottoGroup? = nil
    var numbers: LottoNumbers = .init(numbers: [])
    var presentEmptyBool: Bool = true
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 16) {
            if let group {
                Text(group.id)
                    .font(.headline)
                    .foregroundStyle(Color.primaryColor)
            }
            
            lottoBalls
            
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
    
    var lottoBalls: some View {
        HStack(spacing: 8) {
            if numbers.numbers.count < 1 {
                ForEach(0..<6, id:\.self) { _ in
                    LottoBall(number: nil)
                }
            } else if numbers.numbers.count < 6 {
                ForEach(numbers.numbers.sorted(), id:\.self) { number in
                    LottoBall(number: number,
                              fixed: numbers.fixedNumbers.contains(number))
                }
                
                if presentEmptyBool {
                    ForEach(0..<6-numbers.numbers.count, id:\.self) { _ in
                        LottoBall(number: nil)
                    }
                }
            } else {
                ForEach(numbers.numbers.sorted(), id:\.self) { number in
                    LottoBall(number: number,
                              fixed: numbers.fixedNumbers.contains(number))
                }
            }
        }
    }
}

#Preview {
    VStack {
        ForEach(LottoGroup.allCases) { group in
            LottoRow(group: group) { }
        }
        
        LottoRow()
    }
}
