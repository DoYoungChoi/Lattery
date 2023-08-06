//
//  PensionBallRow.swift
//  Lattery
//
//  Created by dodor on 2023/07/31.
//

import SwiftUI

struct PensionBallRow: View {
    var group: [Int16]
    var showRemove: Bool = false
    
    var body: some View {
        HStack {
            ForEach(Array(group.enumerated()), id:\.offset) { (index, number) in
                PensionBall(number: number, unit: index)
                if index == 0 {
                    Text("조")
                        .font(.system(size: 20))
                }
            }
            
            if showRemove {
                Button {
                    withAnimation { }
                } label: {
                    Image(systemName: "minus")
                        .foregroundColor(.customGray)
                }
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .center)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.backgroundGray)
        }
    }
}

struct PensionBallRow_Previews: PreviewProvider {
    static var previews: some View {
        PensionBallRow(group: [1,5,3,6,8,3,5])
    }
}
