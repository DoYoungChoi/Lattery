//
//  LottoCombinationView.swift
//  Lattery
//
//  Created by dodor on 2023/08/07.
//

import SwiftUI
import CoreData

struct LottoCombinationView: View {
    @EnvironmentObject var data: LottoData
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.round, order: .reverse)
    ]) var lottos: FetchedResults<LottoEntity>
    @State private var ascending: Bool = false // descending
    @State private var includeBonus: Bool = false
    @State private var showNumberBoard: Bool = false
    private var filteredLottos: [LottoEntity] {
        if data.numberCombination.count < 1 { return [] }
        
        return lottos.filter { lotto in
            var numbers: Set<Int16> = [lotto.no1, lotto.no2, lotto.no3, lotto.no4, lotto.no5, lotto.no6]
            if includeBonus { numbers.insert(lotto.noBonus) }
            return data.numberCombination.isSubset(of: numbers)
        }
    }

    var body: some View {
        VStack {
            HStack {
                Text(verbatim: "총 \(lottos.count)회 중 \(filteredLottos.count)건")
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
            
            Button {
                showNumberBoard.toggle()
            } label: {
                HStack {
                    if data.numberCombination.count < 1 {
                        ForEach(0..<6, id:\.self) { _ in
                            LottoBall(number: 0)
                        }
                    } else {
                        ForEach(Array(data.numberCombination.sorted()), id:\.self) { number in
                            LottoBall(number: number)
                        }
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.backgroundGray)
                }
            }
            
            List {
                HStack {
                    Rectangle()
                        .frame(width: 5)
                        .foregroundColor(.backgroundGray)
                    
                    Toggle("회차 오름차순", isOn: $ascending)
                        .tint(.customPink)
                }
                
                ForEach(filteredLottos) { lotto in
                    NavigationLink {
                        LottoResultDetail(lotto: lotto)
                    } label: {
                        LottoCombinationRow(lotto: lotto,
                                           selected: data.numberCombination,
                                           includeBonus: includeBonus)
                    }
                }
            }
            .padding(.leading, -15)
            .listStyle(.inset)
        }
        .sheet(isPresented: $showNumberBoard) {
            LottoNumberBoard(forStat: true)
        }
        .onChange(of: ascending) { newValue in
            let order: SortOrder = newValue ? .forward : .reverse
            lottos.sortDescriptors = [SortDescriptor(\.round, order: order)]
        }
    }
}

struct LottoCombinationView_Previews: PreviewProvider {
    static var previews: some View {
        LottoCombinationView()
            .environmentObject(LottoData())
    }
}
