//
//  RatioBarGraph.swift
//  Lattery
//
//  Created by dodor on 2023/07/12.
//

import SwiftUI

struct RatioBarGraph: View {
    let data: [GraphData]
    var axis: Axis = .vertical
    var titleSpace: CGFloat = 13
    private var sorted: [GraphData] {
        data.sorted { $0.order < $1.order }
    }
    private var total: Double {
        data.map { $0.value }.reduce(0, +)
    }
    
    var body: some View {
        GeometryReader { geo in
            if axis == .vertical {
                let height = round((geo.size.height - titleSpace) / 10) * 10
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(sorted.reversed().enumerated()), id:\.offset) { (index, bar) in
                        let percent = bar.value / total * 100
                        if percent > 0 {
                            RoundedRectangle(cornerRadius: 3)
                                .foregroundColor(bar.color)
                                .frame(height: percent / 100 * height)
                                .overlay {
                                    Text(String(format: "%.0f", percent))
                                        .font(.system(size: 10))
                                }
                        }
                    }
                    
                    Text(sorted.first?.name ?? "")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            } else {
                let width = round((geo.size.width - titleSpace) / 10) * 10
                HStack(alignment: .top, spacing: 0) {
                    Text(sorted.first?.name ?? "")
                        .frame(maxHeight: .infinity, alignment: .center)
                        .frame(maxWidth: 50, alignment: .leading)
                    
                    ForEach(Array(sorted.enumerated()), id:\.offset) { (index, bar) in
                        let percent = bar.value / total * 100
                        if percent > 0 {
                            RoundedRectangle(cornerRadius: 3)
                                .foregroundColor(bar.color)
                                .frame(width: percent / 100 * width)
                                .overlay {
                                    Text(String(format: "%.0f", percent))
                                        .font(.system(size: 10))
                                }
                        }
                    }
                }
            }
        }
    }
}

struct RatioBarGraph_Previews: PreviewProvider {
    static var previews: some View {
        RatioBarGraph(data: GraphData.samplesForRatio)
        RatioBarGraph(data: GraphData.samplesForRatio, axis: .horizontal)
    }
}
