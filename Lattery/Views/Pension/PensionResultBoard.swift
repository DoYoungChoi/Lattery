//
//  PensionResultBoard.swift
//  Lattery
//
//  Created by dodor on 2023/08/03.
//

import SwiftUI
import CoreData

struct PensionResultBoard: View {
    @FetchRequest var pensions: FetchedResults<PensionEntity>
    
    init() {
        // Core Data 처리
        let request: NSFetchRequest<PensionEntity> = PensionEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \PensionEntity.round, ascending: false)
        ]

        request.fetchLimit = 1
        _pensions = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        VStack {
            if let lastestPension = pensions.first {
                let winNumber = lastestPension.winNumbers ?? ""
                let bonusNumber = lastestPension.bonusNumbers ?? ""
                HStack {
                    Text("\(lastestPension.round)회")
                        .bold()
                        .foregroundColor(.red)
                    Text("당첨결과🎊")
                }
                .font(.title)
                
                Text("(\(lastestPension.date?.toDateStringKor ?? "yyyy년 MM월 dd일") 추첨)")
                    .font(.callout)
                    .foregroundColor(.primary.opacity(0.7))
                
                VStack {
                    HStack {
                        Text("1등")
                            .bold()
                        Spacer()
                        Text("월 700만원 X 20년")
                    }
                    HStack {
                        Spacer()
                        PensionBall(number: lastestPension.winClass, unit: 0)
                        Text("조")
                        ForEach(Array(winNumber.enumerated()), id:\.offset) { (index, char) in
                            PensionBall(number: Int16(String(char)), unit: index+1)
                        }
                    }
                }
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.background.opacity(0.5))
                }
                
                VStack {
                    HStack {
                        Text("보너스")
                            .bold()
                        Spacer()
                        Text("월 100만원 X 10년")
                    }
                    
                    HStack {
                        Spacer()
                        Text("각 조")
                        ForEach(Array(bonusNumber.enumerated()), id:\.offset) { (index, char) in
                            PensionBall(number: Int16(String(char)), unit: index+1)
                        }
                    }
                }
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.background.opacity(0.5))
                }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.thinMaterial)
        }
    }
}

struct PensionResultBoard_Previews: PreviewProvider {
    static var previews: some View {
        PensionResultBoard()
    }
}
