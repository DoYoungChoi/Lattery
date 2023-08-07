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
    @State private var includeBonus: Bool = false
    @State private var selection: ColorStatType = .total
    private enum ColorStatType: String, CaseIterable, Identifiable {
        case total = "전체 통계"
        case position = "위치별 통계"
        var id: String { self.rawValue }
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                HStack {
                    Text(verbatim: "총 \(lottos.count)회")
                        .bold()
                    Spacer()
                    Button {
                        includeBonus.toggle()
                    } label: {
                        Label {
                            Text("보너스 포함")
                        } icon: {
                            Image(systemName: includeBonus ? "checkmark.square.fill" : "checkmark.square")
                                .foregroundColor(.customPink)
                        }
                    }
                }
                
                HStack {
                    ForEach(Array(colorSet.enumerated()), id: \.offset) { (index, color) in
                        let startNumber = 10 * index + 1
                        HStack(spacing: 1) {
                            Image(systemName: "square.fill")
                                .foregroundColor(color.opacity(0.7))
                            Text("\(startNumber)~\(startNumber > 40 ? 45 : startNumber + 9)")
                                .font(.system(size: 13))
                        }
                    }
                }
                .padding(8)
                .font(.system(size: 13))
                .frame(maxWidth: .infinity, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.backgroundGray)
                }
                
                ColorStatTypePicker(selection: $selection)
                
                HStack {
                    Spacer()
                    Text("단위: [ % ]")
                        .foregroundColor(.customGray)
                }
                
                if selection == .total {
                    PieChart(data: totalData)
                } else {
                    VStack {
                        RatioBarGraph(data: sortedData(1), axis: .horizontal, titleSpace: 40)
                        RatioBarGraph(data: sortedData(2), axis: .horizontal, titleSpace: 40)
                        RatioBarGraph(data: sortedData(3), axis: .horizontal, titleSpace: 40)
                        RatioBarGraph(data: sortedData(4), axis: .horizontal, titleSpace: 40)
                        RatioBarGraph(data: sortedData(5), axis: .horizontal, titleSpace: 40)
                        RatioBarGraph(data: sortedData(6), axis: .horizontal, titleSpace: 40)
                        if includeBonus {
                            Image(systemName: "plus")
                                .padding(.leading, 30)
                            RatioBarGraph(data: sortedData(7), axis: .horizontal, titleSpace: 40)
                        }
                    }
                    .font(.system(size: 15))
                }
            }
        }
    }
    
    private struct ColorStatTypePicker: View {
        @Binding var selection: ColorStatType
        
        var body: some View {
            HStack {
                ForEach(ColorStatType.allCases) { type in
                    VStack(spacing: 0) {
                        Text(type.id)
                            .padding(.vertical, 10)
                        
                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(.customPink)
                            .opacity(selection == type ? 1 : 0)
                    }
                    .background(.background)
                    .opacity(selection == type ? 1 : 0.3)
                    .onTapGesture {
                        withAnimation {
                            selection = type
                        }
                    }
                }
            }
        }
    }
    
    private var totalData: [GraphData] {
        var info = [GraphData]()
        let values: [Int] = lottos.reduce([0,0,0,0,0]) { (sum, entity) in
            var numbers = [entity.no1, entity.no2, entity.no3, entity.no4, entity.no5, entity.no6]
            if includeBonus { numbers.append(entity.noBonus) }
            
            return [
                sum[0] + numbers.filter({ $0 > 0 && $0 < 11 }).count,
                sum[1] + numbers.filter({ $0 > 10 && $0 < 21 }).count,
                sum[2] + numbers.filter({ $0 > 20 && $0 < 31 }).count,
                sum[3] + numbers.filter({ $0 > 30 && $0 < 41 }).count,
                sum[4] + numbers.filter({ $0 > 40 && $0 < 45 }).count
            ]
        }
        
        for (index, color) in colorSet.enumerated() {
            let range: String = index == 4 ? "41~45" : "\(String(format: "%.0f", index * 10 + 1))~\(index * 10 + 10)"
            let data = GraphData(name: range,
                                 value: Double(values[index]),
                                 color: color.opacity(0.7))
            info.append(data)
        }
        return info
    }
    
    private func sortedData(_ nth: Int) -> [GraphData] {
        var info = [GraphData]()
        let data = nth == 1 ? lottos.map { $0.no1 }
                   : nth == 2 ? lottos.map { $0.no2 }
                   : nth == 3 ? lottos.map { $0.no3 }
                   : nth == 4 ? lottos.map { $0.no4 }
                   : nth == 5 ? lottos.map { $0.no5 }
                   : nth == 6 ? lottos.map { $0.no6 }
                   : nth == 7 ? lottos.map { $0.noBonus }
                   : []
        
        for (index, color) in colorSet.enumerated() {
            let data = GraphData(name: nth == 7 ? "보너스" : "\(nth)번째",
                                 value: Double(data.filter { $0 > 10 * index && $0 < 10 * index + 11 }.count),
                                 color: color.opacity(0.7),
                                 order: index)
            info.append(data)
        }
        return info
    }
}

//struct LottoRatioGraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        LottoRatioGraphView()
//    }
//}
