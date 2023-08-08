//
//  PensionBallRow.swift
//  Lattery
//
//  Created by dodor on 2023/07/31.
//

import SwiftUI

struct PensionBallRow: View {
    var group: [Int16]
    var removeAction: (() -> ())? = nil
    
    var body: some View {
        HStack {
            ForEach(Array(group.enumerated()), id:\.offset) { (index, number) in
                PensionBall(number: number, unit: index)
                if index == 0 {
                    Text("조")
                        .font(.system(size: 20))
                }
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .center)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.backgroundGray)
                .overlay {
                    if let action = removeAction {
                        Button {
                            withAnimation { action() }
                        } label: {
                            Image(systemName: "minus")
                                .foregroundColor(.accentColor)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 10)
                        }
                    }
                }
        }
    }
}

struct PensionBallRow_Previews: PreviewProvider {
    static var previews: some View {
        PensionBallRow(group: [1,5,3,6,8,3,5])
    }
}
