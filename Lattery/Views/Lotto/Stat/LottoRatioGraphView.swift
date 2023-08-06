//
//  LottoRatioGraphView.swift
//  Lattery
//
//  Created by dodor on 2023/07/12.
//

import SwiftUI

struct LottoRatioGraphView: View {
    @FetchRequest(sortDescriptors: []) var lottos: FetchedResults<LottoEntity>
    let colorSet: [Color] = [.customYellow, .customBlue, .customRed, .customDarkGray, .customGreen]
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    ForEach(Array(colorSet.enumerated()), id: \.offset) { (index, color) in
                        let startNumber = 10 * index + 1
                        HStack(spacing: 1) {
                            Image(systemName: "square.fill")
                                .foregroundColor(color.opacity(0.7))
                            Text("\(startNumber)~\(startNumber > 40 ? 45 : startNumber + 9)")
                        }
                    }
                }
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.backgroundGray)
                }
            
                HStack {
                    Text(verbatim: "총 \(lottos.count)회")
                    Spacer()
                    Text("[ 단위: % ]")
                }
                
                VStack {
                    RatioBarGraph(data: sortedData(1), axis: .horizontal, titleSpace: 40)
                    RatioBarGraph(data: sortedData(2), axis: .horizontal, titleSpace: 40)
                    RatioBarGraph(data: sortedData(3), axis: .horizontal, titleSpace: 40)
                    RatioBarGraph(data: sortedData(4), axis: .horizontal, titleSpace: 40)
                    RatioBarGraph(data: sortedData(5), axis: .horizontal, titleSpace: 40)
                    RatioBarGraph(data: sortedData(6), axis: .horizontal, titleSpace: 40)
                    Image(systemName: "plus")
                        .padding(.leading, 30)
                    RatioBarGraph(data: sortedData(7), axis: .horizontal, titleSpace: 40)
                }
            }
            .font(.system(size: geo.size.width / 26))
        }
    }
    
    private func sortedData(_ nth: Int) -> [Bar] {
        var info = [Bar]()
        let data = nth == 1 ? lottos.map { $0.no1 }
                   : nth == 2 ? lottos.map { $0.no2 }
                   : nth == 3 ? lottos.map { $0.no3 }
                   : nth == 4 ? lottos.map { $0.no4 }
                   : nth == 5 ? lottos.map { $0.no5 }
                   : nth == 6 ? lottos.map { $0.no6 }
                   : nth == 7 ? lottos.map { $0.noBonus }
                   : []
        
        for (index, color) in colorSet.enumerated() {
            let bar = Bar(name: nth == 7 ? "보너스" : "\(nth)번째",
                          value: Double(data.filter { $0 > 10 * index && $0 < 10 * index + 11 }.count),
                          color: color.opacity(0.7),
                          order: index)
            info.append(bar)
        }
        return info
    }
}

//struct LottoRatioGraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        LottoRatioGraphView()
//    }
//}
