//
//  BarGraph.swift
//  Lattery
//
//  Created by dodor on 2023/07/10.
//

import SwiftUI

struct Bar: Identifiable {
    let id = UUID()
    var name: String
    var value: Double
    var color: Color = .accentColor
    var order: Int = 0
    
    static var samples: [Bar] {
        var tempBars = [Bar]()
        
        for i in 1...70 {
            let rand = Double.random(in: 20..<300)
            let bar = Bar(name: "\(i)",
                          value: rand)
            tempBars.append(bar)
        }
        
        return tempBars
    }
    
    static var samplesForRatio: [Bar] {
        var tempBars = [Bar]()
        let colors = [Color.latteYellow,
                      Color.latteBlue,
                      Color.latteRed,
                      Color.latteGray,
                      Color.latteGreen]
        
        for (i, color) in colors.enumerated() {
            let rand = Double.random(in: 20..<300)
            let bar = Bar(name: "\(i)",
                          value: rand,
                          color: color,
                          order: i)
            tempBars.append(bar)
        }
        
        return tempBars
    }
}

struct BarGraph: View {
    let data: [Bar]
    @State private var offset: CGPoint = CGPoint()
//    @State private var displayed: [Bar] = []
//    private var upperLimit: Double {
//        ceil((displayed.map { $0.value }.max() ?? 1) / 100) * 100
//    }
//    let width = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            OffsetObservingScrollView(axes: .horizontal,
                                      showsIndicators: false,
                                      offset: $offset) {
                LazyHStack(alignment: .bottom) {
                    ForEach(data) { bar in
                        VStack {
                            Text(String(format: "%.0f", bar.value))
                                .font(.system(size: 10))
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(bar.color)
                                    .frame(width: 35,
                                           height: bar.value * 1.1,
                                           alignment: .bottom)
                            }
                            
                            Text("\(bar.name)")
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct BarGraph_Previews: PreviewProvider {
    static var previews: some View {
        BarGraph(data: Bar.samples)
    }
}
