//
//  LottoCountGraphView.swift
//  Lattery
//
//  Created by dodor on 2023/07/10.
//

import SwiftUI

struct LottoCountGraphView: View {
    @FetchRequest(sortDescriptors: []) var lottos: FetchedResults<LottoEntity>
    @State private var statMode: Mode = .ordered
    private enum Mode: String, Identifiable, CaseIterable {
        case ordered = "번호순"
        case sorted = "당첨횟수순"
        var id: String { rawValue }
    }
    @State private var data: [GraphData] = []
    private var sortedData: [GraphData] {
        data.sorted { $0.value > $1.value }
    }
    @State private var includeBonus: Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                Text(verbatim: "총 \(lottos.count)회")
                    .bold()
                Spacer()
                
                VStack(alignment: .trailing) {
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
                    
                    Picker("", selection: $statMode) {
                        ForEach(Mode.allCases) { mode in
                            Text(mode.id)
                                .tag(mode)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            
            if lottos.count > 0 {
                BarGraph(data: statMode == .ordered ? data : sortedData,
                         axis: .horizontal)
            } else {
                Text("로또 데이터가 없습니다.\n새로고침 버튼을 눌러 데이터를 가져오세요.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.customGray)
                    .padding(.vertical)
            }
        }
        .onAppear(perform: setData)
        .onChange(of: includeBonus) { _ in
            setData()
        }
    }
    
    private func setData() {
        data = []
        for i in 1...45 {
            data.append(GraphData(name: String(i), value: count(Int16(i))))
        }
    }
    
    private func count(_ number: Int16) -> Double {
        let numbers = lottos.map {
            var numbers = [$0.no1, $0.no2, $0.no3, $0.no4, $0.no5, $0.no6]
            if includeBonus { numbers.append($0.noBonus) }
            return numbers
        }
        
        return Double(numbers.filter({ $0.contains(number) }).count)
    }
}

//struct LottoCountGraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        LottoCountGraphView()
//    }
//}
