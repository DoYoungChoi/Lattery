//
//  PensionRatioGraphView.swift
//  Lattery
//
//  Created by dodor on 2023/08/03.
//

import SwiftUI

struct PensionRatioGraphView: View {
    @FetchRequest(sortDescriptors: []) var pensions: FetchedResults<PensionEntity>
    let colorSet: [Color] = [.latteLightGray, .latteRed, .latteOrange, .latteYellow, .latteGreen,
                             .latteLightBlue, .latteBlue, .lattePurple, .latteIvory, .lattePink]
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    ForEach(Array(colorSet.enumerated()), id: \.offset) { (index, color) in
                        HStack(spacing: 1) {
                            Image(systemName: "square.fill")
                                .foregroundColor(color)
                            Text("\(index)")
                        }
                    }
                }
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.thinMaterial)
                }
            
                HStack {
                    Text(verbatim: "총 \(pensions.count)회")
                    Spacer()
                    Text("[ 단위: % ]")
                }
                
                HStack(alignment: .bottom) {
                    RatioBarGraph(data: sortedData(0), axis: .vertical)
                    RatioBarGraph(data: sortedData(1), axis: .vertical)
                    RatioBarGraph(data: sortedData(2), axis: .vertical)
                    RatioBarGraph(data: sortedData(3), axis: .vertical)
                    RatioBarGraph(data: sortedData(4), axis: .vertical)
                    RatioBarGraph(data: sortedData(5), axis: .vertical)
                    RatioBarGraph(data: sortedData(6), axis: .vertical)
                }
            }
            .font(.system(size: geo.size.width / 26))
        }
    }
    
    private func getWin(number: String?, at offset: Int) -> Int16 {
        guard let numberString = number, numberString.count > offset else { return -1 }
        let numberUnit = numberString.at(offset)
        return Int16(numberUnit) ?? -1
    }
    
    private func sortedData(_ nth: Int) -> [Bar] {
        var info = [Bar]()
        let data: [Int16] = nth == 0 ? pensions.map { $0.winClass }
                            : nth == 1 ? pensions.map { getWin(number: $0.winNumbers, at: 0) }
                            : nth == 2 ? pensions.map { getWin(number: $0.winNumbers, at: 1) }
                            : nth == 3 ? pensions.map { getWin(number: $0.winNumbers, at: 2) }
                            : nth == 4 ? pensions.map { getWin(number: $0.winNumbers, at: 3) }
                            : nth == 5 ? pensions.map { getWin(number: $0.winNumbers, at: 4) }
                            : nth == 6 ? pensions.map { getWin(number: $0.winNumbers, at: 5) }
                            : []
        
        var name: String {
            switch (nth) {
                case 0: return "조"
                case 1: return "십만"
                case 2: return "만"
                case 3: return "천"
                case 4: return "백"
                case 5: return "십"
                case 6: return "일"
                default: return ""
            }
        }
        
        for (index, color) in colorSet.enumerated() {
            let bar = Bar(name: name,
                          value: Double(data.filter({ $0 == index }).count),
                          color: color,
                          order: index)
            info.append(bar)
        }
        return info
    }
}

struct PensionRatioGraphView_Previews: PreviewProvider {
    static var previews: some View {
        PensionRatioGraphView()
    }
}
