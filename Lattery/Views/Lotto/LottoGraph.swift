//
//  LottoGraph.swift
//  Lattery
//
//  Created by dodor on 2023/07/10.
//

import SwiftUI

struct LottoGraph: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.nth, order: .reverse)]) var lottos: FetchedResults<LottoEntity>
    @State private var statMode: Mode = .ordered
    private enum Mode: String, Identifiable, CaseIterable {
        case ordered = "번호순"
        case sorted = "당첨횟수순"
        var id: String { rawValue }
    }
    @State private var data: [Bar] = []
    private var sortedData: [Bar] {
        data.sorted { $0.value > $1.value }
    }
    
    var body: some View {
        VStack {
            Picker("", selection: $statMode) {
                ForEach(Mode.allCases) { mode in
                    Text(mode.id)
                        .tag(mode)
                }
            }
            .pickerStyle(.menu)
            
            BarGraph(data: statMode == .ordered ? data : sortedData)
        }
        .onAppear {
            for i in 1...45 {
                data.append(Bar(name: String(i), value: count(Int16(i))))
            }
        }
    }
    
    private func count(_ number: Int16) -> Double {
        return Double(lottos.map { [$0.no1, $0.no2, $0.no3, $0.no4, $0.no5, $0.no6] }.filter { $0.contains(number) }.count)
    }
    
//    private func percent(_ number: Int16) -> Double {
//        if lottos.count == 0 { return 0.0 }
//        let count = lottos.map { [$0.no1, $0.no2, $0.no3, $0.no4, $0.no5, $0.no6] }.filter { $0.contains(number) }.count
//        return Double(count) / Double(lottos.count) * 100
//    }
}

//struct LottoGraph_Previews: PreviewProvider {
//    static var previews: some View {
//        LottoGraph()
//    }
//}
