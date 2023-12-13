//
//  PensionResultView.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct PensionResultView: View {
    
    let pension: PensionEntity
    private let infos: [String] = [
        "월 700만원 X 20년",
        "월 100만원 X 10년",
        "1백만원",
        "1십만원",
        "5만원",
        "5천원",
        "1천원",
        "월 100만원 X 10년"
    ]
    private var winNumbers: [Int?] {
        pension.numbers.toPensionNumbers
    }
    private var bonusNumbers: [Int?] {
        let count = pension.bonus.toPensionNumbers.count
        return Array(pension.bonus.toPensionNumbers[1..<count])
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(verbatim: "\(pension.round)회 당첨결과")
                .font(.largeTitle)
            
            Text("\(pension.date.toDateStringKor) 추첨")
                .font(.headline)
                .foregroundStyle(Color.gray2)
            
            ForEach(Array(infos.enumerated()), id:\.offset) { (rank, info) in
                VStack(spacing: 4) {
                    HStack {
                        Text("\(rank == 7 ? "보너스" : "\(rank+1)등")")
                            .font(.headline)
                            .foregroundStyle(Color.primaryColor)
                        Spacer()
                        Text("\(info)")
                            .font(.body)
                    }
                    
                    if rank == 7 {
                        bonusBalls
                    } else {
                        rankBalls(rank)
                    }
                }
            }
            
            Spacer()
        }
    }
    
    private var bonusBalls: some View {
        HStack(spacing: 8) {
            Spacer()
            Text("각 조")
                .font(.subheadline)
                .foregroundStyle(Color.primaryColor)
            ForEach(Array(bonusNumbers.enumerated()), id:\.offset) { (index, number) in
                PensionBall(position: index+1,
                            number: number ?? -1)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.backgroundGray)
        }
    }
    
    private func rankBalls(_ rank: Int) -> some View {
        HStack(spacing: 8) {
            Spacer()
            
            ForEach(Array(winNumbers.enumerated()), id:\.offset) { (index, number) in
                if index >= rank {
                    PensionBall(position: index,
                                number: number ?? -1)
                    if rank == 0 && index == 0 {
                        Text("조")
                            .font(.subheadline)
                            .foregroundStyle(Color.primaryColor)
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.backgroundGray)
        }
    }
}

