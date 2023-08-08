//
//  PieChart.swift
//  Lattery
//
//  Created by dodor on 2023/08/07.
//

import SwiftUI

struct PieChart: View {
    let data: [GraphData]
    var innerFraction: CGFloat = 0.5
    
    private var total: Double {
        data.reduce(0) { $0 + $1.value }
    }
    private var slices: [PieSliceData] {
        var endDegree: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for e in data {
            let degree: Double = e.value / total * 360
            tempSlices.append(PieSliceData(name: e.name,
                                           value: degree / 360 * 100,
                                           startAngle: Angle(degrees: endDegree),
                                           endAngle: Angle(degrees: endDegree + degree),
                                           color: e.color))
            endDegree += degree
        }
        
        return tempSlices
    }
    private struct PieSliceData: Identifiable {
        var name: String
        var value: Double
        var startAngle: Angle
        var endAngle: Angle
        var color: Color
        
        var id: String { self.name }
    }
    @State private var displayed: PieSliceData?
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                ZStack{
                    ForEach(slices) { slice in
                        PieSlice(slice: slice)
                            .scaleEffect(displayed?.id == slice.id ? 1.05 : 1)
                            .onTapGesture {
                                withAnimation { displayed = slice }
                            }
                    }
                    .frame(width: geo.size.width, height: geo.size.width)
                    
                    Circle()
                        .fill(.background)
                        .frame(width: geo.size.width * innerFraction,
                               height: geo.size.width * innerFraction)
                    
                    if let displayed = displayed {
                        VStack {
                            HStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(displayed.color)
                                Text(displayed.name)
                                    .bold()
                            }
                            
                            Text("\(String(format: "%.0f", displayed.value / 100 * total)) [\(String(format: "%.0f", displayed.value))%]")
                                .foregroundColor(.customGray)
                                .bold()
                        }
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            displayed = slices.first
        }
    }
    
    private struct PieSlice: View {
        var slice: PieSliceData
        
        private var midRadians: Double {
            return Double.pi / 2.0 - (slice.startAngle + slice.endAngle).radians / 2.0
        }
        
        var body: some View {
            GeometryReader { geo in
                ZStack {
                    Path { path in
                        let width: CGFloat = min(geo.size.width, geo.size.height)
                        let height = width
                        
                        let center = CGPoint(x: width * 0.5, y: height * 0.5)
                        
                        path.move(to: center)
                        
                        path.addArc(
                            center: center,
                            radius: width * 0.5,
                            startAngle: Angle(degrees: -90.0) + slice.startAngle,
                            endAngle: Angle(degrees: -90.0) + slice.endAngle,
                            clockwise: false)
                    }
                    .fill(slice.color)
                    
                    Text(String(format: "%.0f", slice.value))
                       .position(x: geo.size.width * 0.5 * CGFloat(1.0 + 0.78 * cos(self.midRadians)),
                                 y: geo.size.height * 0.5 * CGFloat(1.0 - 0.78 * sin(self.midRadians)))
                }
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        PieChart(data: GraphData.samplesForPie,
                 innerFraction: 0.5)
    }
}
