//
//  BarGraph.swift
//  Lattery
//
//  Created by dodor on 2023/07/10.
//

import SwiftUI

struct GraphData: Identifiable {
    let id = UUID()
    var name: String
    var value: Double
    var color: Color = .customPink
    var order: Int = 0
    
    static var samples: [GraphData] {
        var tempData = [GraphData]()
        
        for i in 1...70 {
            let rand = Double.random(in: 20..<300)
            let data = GraphData(name: "\(i)",
                                 value: rand)
            tempData.append(data)
        }
        
        return tempData
    }
    
    static var samplesForRatio: [GraphData] {
        var tempData = [GraphData]()
        let colors: [Color] = [.customYellow, .customBlue, .customRed, .customDarkGray, .customGreen]
        
        for (i, color) in colors.enumerated() {
            let rand = Double.random(in: 20..<300)
            let data = GraphData(name: "\(i)",
                                 value: rand,
                                 color: color,
                                 order: i)
            tempData.append(data)
        }
        
        return tempData
    }
    
    static var samplesForPie: [GraphData] {
        var tempData = [GraphData]()
        let colors = [Color.customRed, Color.customOrange, Color.customYellow,
                      Color.customGreen, Color.customBlue, Color.customPurple]
        
        for (i, color) in colors.enumerated() {
            let rand = Double.random(in: 1...10)
            let data = GraphData(name: "\(i)",
                                 value: rand,
                                 color: color)
            tempData.append(data)
        }
        
        return tempData
    }
}

struct BarGraph: View {
    let data: [GraphData]
    var axis: Axis = .vertical
    var titleSpace: CGFloat = 30
    @State private var offset: CGPoint = CGPoint()
    private var maxValue: Double {
        data.map { $0.value }.max() ?? 0
    }
    
    var body: some View {
        GeometryReader { geo in
            if axis == .vertical {
                let height = round((geo.size.height - titleSpace) / 10) * 10
                OffsetObservingScrollView(axes: .horizontal,
                                          showsIndicators: false,
                                          offset: $offset) {
                    LazyHStack(alignment: .bottom) {
                        ForEach(data) { bar in
                            VStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(bar.color)
                                    .frame(width: 35,
                                           height: bar.value / maxValue * height)
                                    .overlay {
                                        Text(String(format: "%.0f", bar.value))
                                            .font(.system(size: 10))
                                    }
                                
                                Text("\(bar.name)")
                            }
                        }
                    }
                }
            } else {
                let width = round((geo.size.width - titleSpace - 10) / 10) * 10
                OffsetObservingScrollView(axes: .vertical,
                                          showsIndicators: false,
                                          offset: $offset) {
                    LazyVStack(alignment: .leading) {
                        ForEach(data) { bar in
                            HStack {
                                Text("\(bar.name)")
                                    .frame(width: titleSpace)
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(bar.color)
                                    .frame(width: bar.value / maxValue * width,
                                           height: 35)
                                    .overlay {
                                        Text(String(format: "%.0f", bar.value))
                                            .font(.system(size: 10))
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct BarGraph_Previews: PreviewProvider {
    static var previews: some View {
        BarGraph(data: GraphData.samples)
        BarGraph(data: GraphData.samples, axis: .horizontal)
    }
}
