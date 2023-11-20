//
//  PensionRatioGraphView.swift
//  Lattery
//
//  Created by dodor on 2023/08/03.
//

import SwiftUI

struct PensionRatioGraphView: View {
    @FetchRequest(sortDescriptors: []) var pensions: FetchedResults<PensionEntity>
    let colorSet: [Color] = [.customGray, .customRed, .customOrange, .customYellow, .customGreen,
                             .customLightBlue, .customBlue, .customPurple, .customPink, .customDarkGray]
    @State private var includeBonus: Bool = false
    @State private var selection: ColorStatType = .total
    private enum ColorStatType: String, CaseIterable, Identifiable {
        case total = "전체 통계"
        case position = "위치별 통계"
        var id: String { self.rawValue }
    }
    private var totalData: [GraphData] {
        var info = [GraphData]()
        let values: [Int] = pensions.reduce([0,0,0,0,0,0,0,0,0,0]) { (sum, entity) in
            var numbers: String = entity.winNumbers ?? ""
            if includeBonus { numbers += entity.bonusNumbers ?? "" }
            
            return [
                sum[0] + numbers.filter({ $0 == "0" }).count,
                sum[1] + numbers.filter({ $0 == "1" }).count,
                sum[2] + numbers.filter({ $0 == "2" }).count,
                sum[3] + numbers.filter({ $0 == "3" }).count,
                sum[4] + numbers.filter({ $0 == "4" }).count,
                sum[5] + numbers.filter({ $0 == "5" }).count,
                sum[6] + numbers.filter({ $0 == "6" }).count,
                sum[7] + numbers.filter({ $0 == "7" }).count,
                sum[8] + numbers.filter({ $0 == "8" }).count,
                sum[9] + numbers.filter({ $0 == "9" }).count
            ]
        }
        
        for (index, color) in colorSet.enumerated() {
            let data = GraphData(name: String(index),
                                 value: Double(values[index]),
                                 color: color.opacity(0.7))
            info.append(data)
        }
        return info
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Text(verbatim: "총 \(pensions.count)회")
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
                        HStack(spacing: 1) {
                            Image(systemName: "square.fill")
                                .foregroundColor(color.opacity(0.7))
                            Text("\(index)")
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
                    Text("[ 단위: % ]")
                        .foregroundColor(.accentColor)
                }
                
                if pensions.count > 0 {
                    if selection == .total {
                        PieChart(data: totalData)
                    } else {
                        VStack(alignment: .leading) {
                            Text("1등 번호")
                                .bold()
                            HStack(alignment: .bottom) {
                                ForEach(0...6, id:\.self) { nth in
                                    RatioBarGraph(data: sortedData(nth), axis: .vertical)
                                }
                            }
                            
                            if includeBonus {
                                Text("보너스 번호")
                                    .bold()
                                    .padding(.top, 10)
                                HStack(alignment: .bottom) {
                                    ForEach(0...6, id:\.self) { nth in
                                        RatioBarGraph(data: sortedData(nth, forBonus: true), axis: .vertical)
                                            .opacity(nth == 0 ? 0 : 1)
                                    }
                                }
                            }
                        }
                        .font(.system(size: 13))
                    }
                } else {
                    Text("연금복권 데이터가 없습니다.\n새로고침 버튼을 눌러 데이터를 가져오세요.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.customGray)
                        .padding(.vertical)
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
    
    private func getWinNumber(_ number: String?, at offset: Int) -> Int16 {
        guard let numberString = number, numberString.count > offset else { return -1 }
        let numberUnit = numberString.at(offset)
        return Int16(numberUnit) ?? -1
    }
    
    private func sortedData(_ nth: Int, forBonus: Bool = false) -> [GraphData] {
        var info = [GraphData]()
        let data: [Int16] = nth == 0 ? pensions.map { $0.winClass }
                            : nth > 0 && nth < 7 && forBonus ? pensions.map { getWinNumber($0.bonusNumbers, at: nth - 1) }
                            : nth > 0 && nth < 7 ? pensions.map { getWinNumber($0.winNumbers, at: nth - 1) }
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
            let bar = GraphData(name: name,
                          value: Double(data.filter({ $0 == index }).count),
                          color: color.opacity(0.7),
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
