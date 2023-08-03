//
//  RatioBarGraph.swift
//  Lattery
//
//  Created by dodor on 2023/07/12.
//

import SwiftUI

struct RatioBarGraph: View {
    let data: [Bar]
    var axis: Axis = .vertical
    private var sorted: [Bar] {
        data.sorted { $0.order < $1.order }
    }
    private var total: Double {
        data.map { $0.value }.reduce(0, +)
    }
    
    var body: some View {
        GeometryReader { geo in
            if axis == .vertical {
                let height = geo.size.height - 13
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(sorted.reversed().enumerated()), id:\.offset) { (index, bar) in
                        let value = round(bar.value / total * 100)
                        if value > 0 {
                            RoundedRectangle(cornerRadius: 3)
                                .foregroundColor(bar.color)
                                .frame(maxHeight: index + 1 == data.count ? .infinity : value / 100 * height)
                                .overlay {
                                    Text(String(format: "%.0f", value))
                                        .font(.system(size: 10))
                                }
                        }
                    }
                    
                    Text(sorted.first?.name ?? "")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            } else {
                let width = geo.size.width - 13
                HStack(alignment: .top, spacing: 0) {
                    Text(sorted.first?.name ?? "")
                        .frame(maxHeight: .infinity, alignment: .center)
                        .frame(maxWidth: 50, alignment: .leading)
                    
                    ForEach(Array(sorted.enumerated()), id:\.offset) { (index, bar) in
                        let value = round(bar.value / total * 100)
                        if value > 0 {
                            RoundedRectangle(cornerRadius: 3)
                                .foregroundColor(bar.color)
                                .frame(maxWidth: index + 1 == data.count ? .infinity : value / 100 * width)
                                .overlay {
                                    Text(String(format: "%.0f", value))
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
        RatioBarGraph(data: Bar.samplesForRatio)
        RatioBarGraph(data: Bar.samplesForRatio, axis: .horizontal)
    }
}
