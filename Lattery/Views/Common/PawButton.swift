//
//  Paw.swift
//  Lattery
//
//  Created by dodor on 2023/08/05.
//

import SwiftUI

struct PawButton: View {
    var color: Color
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("paw_background")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width)
                    .blending(color: .backgroundGray)
                
                Image("paw")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.8)
                    .blending(color: color)
                    .shadow(color: .customGray, radius: 3, y: 3)
            }
        }
    }
}

struct Paw_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            ForEach([50,100,200,300,400], id:\.self) { size in
                PawButton(color: .customPink)
                    .frame(height: size)
            }
        }
    }
}
