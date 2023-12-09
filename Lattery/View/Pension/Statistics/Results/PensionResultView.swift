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
    private var winNumbers: String {
        pension.numbers
    }
    private var bonusNumbers: String {
        pension.bonus
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
        }
    }
    
    private var bonusBalls: some View {
        HStack(spacing: 8) {
            Spacer()
            Text("각 조")
            ForEach(Array(bonusNumbers.enumerated()), id:\.offset) { (index, number) in
                PensionBall(position: index + 1,
                            number: Int(String(number)) ?? -1)
            }
        }
        .font(.subheadline)
        .foregroundStyle(Color.primaryColor)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.backgroundGray)
        }
    }
    
    private func rankBalls(_ rank: Int) -> some View {
        HStack(spacing: 8) {
            Spacer()
            
            if rank == 0 {
                PensionBall(position: rank,
                            number: Int(pension.group))
                Text("조")
            }
                
            ForEach(Array(winNumbers.enumerated()), id:\.offset) { (index, number) in
                if index + 1 > rank {
                    PensionBall(position: index + 1,
                                number: Int(String(number)) ?? -1)
                }
            }
        }
        .font(.subheadline)
        .foregroundStyle(Color.primaryColor)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.backgroundGray)
        }
    }
}

