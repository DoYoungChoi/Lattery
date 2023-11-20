//
//  PensionCombinationView.swift
//  Lattery
//
//  Created by dodor on 2023/08/08.
//

import SwiftUI

struct PensionCombinationView: View {
    @EnvironmentObject var data: PensionData
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.round, order: .reverse)
    ]) var pensions: FetchedResults<PensionEntity>
    @State private var ascending: Bool = false // descending
    @State private var includeBonus: Bool = false
    @State private var showNumberBoard: Bool = false
    private var filteredPensions: [PensionEntity] {
        if data.numberCombination.filter({ $0 >= 0 }).count < 1 { return [] }
        
        return pensions.filter { pension in
            // pension winNumber 값 없으면 필터링하지 않음
            guard let winNumbers = pension.winNumbers else { return false }
            
            var result: Bool = true
            for (index, number) in data.numberCombination.enumerated() {
                if number >= 0 {
                    if index == 0 { // 조 비교
                        if pension.winClass != number { return false }
                    } else { // 나머지 숫자 비교
                        if String(winNumbers.at(index-1)) != String(number) {
                            result = false
                        }
                    }
                }
            }
            
            if result == false && includeBonus { // 1등 데이터 비교는 일치 안 함으로 끝났지만 보너스 포함 검색한 경우 한 번 더 기회를 줌
                result = true
                if let bonusNumbers = pension.bonusNumbers {
                    for (index, number) in data.numberCombination.enumerated() {
                        if index > 0 && number >= 0 { // 보너스는 조 비교를 하지 않음
                            if String(bonusNumbers.at(index-1)) != String(number) {
                                result = false
                            }
                        }
                    }
                }
            }
            
            return result
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(verbatim: "총 \(pensions.count)회 중 \(filteredPensions.count)건")
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
            
            if pensions.count > 0 {
                Button {
                    showNumberBoard.toggle()
                } label: {
                    PensionBallRow(group: data.numberCombination)
                }
                
                List {
                    HStack {
                        Rectangle()
                            .frame(width: 5)
                            .foregroundColor(.backgroundGray)
                        
                        Toggle("회차 오름차순", isOn: $ascending)
                            .tint(.customPink)
                    }
                    
                    ForEach(filteredPensions) { pension in
                        NavigationLink {
                            PensionResultDetail(pension: pension)
                        } label: {
                            PensionCombinationRow(pension: pension,
                                                  selected: data.numberCombination,
                                                  includeBonus: includeBonus)
                        }
                    }
                }
                .padding(.leading, -15)
                .listStyle(.inset)
            } else {
                Text("연금복권 데이터가 없습니다.\n새로고침 버튼을 눌러 데이터를 가져오세요.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.customGray)
                    .padding(.vertical)
            }
        }
        .sheet(isPresented: $showNumberBoard) {
            if #available(iOS 16.0, *) {
                PensionNumberBoard(forStat: true)
                    .presentationDetents([.height(480)])
            } else {
                PensionNumberBoard(forStat: true)
            }
        }
        .onChange(of: ascending) { newValue in
            let order: SortOrder = newValue ? .forward : .reverse
            pensions.sortDescriptors = [SortDescriptor(\.round, order: order)]
        }
    }
}

struct PensionCombinationView_Previews: PreviewProvider {
    static var previews: some View {
        PensionCombinationView()
            .environmentObject(PensionData())
    }
}
