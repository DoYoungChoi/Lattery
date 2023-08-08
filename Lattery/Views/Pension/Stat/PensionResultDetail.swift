//
//  PensionResultDetail.swift
//  Lattery
//
//  Created by dodor on 2023/08/03.
//

import SwiftUI

struct PensionResultDetail: View {
    var pension: PensionEntity
    private var winNumber: String {
        pension.winNumbers ?? ""
    }
    private var bonusNumber: String {
        pension.bonusNumbers ?? ""
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: - 당첨일
            Text(verbatim: "\(pension.round)회 당첨결과")
                .font(.largeTitle)
            
            Text("\(pension.date?.toDateStringKor ?? "yyyy년 MM월 dd일") 추첨")
                .font(.title3)
                .foregroundColor(.accentColor)

            ScrollView(showsIndicators: false) {
                // 1등 정보
                winner1st
                
                // 2등 정보
                winner2nd
                
                // 3등 정보
                winner3rd
                
                // 4등 정보
                winner4th
                
                // 5등 정보
                winner5th
                
                // 6등 정보
                winner6th
                
                // 7등 정보
                winner7th
                
                // 보너스 정보
                winnerBonus
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var winner1st: some View {
        VStack(spacing: 5) {
            HStack(spacing: 0) {
                Text("1등")
                    .bold()
                Spacer()
                Text("월 ")
                Text("700")
                    .bold()
                Text("만원 X ")
                Text("20")
                    .bold()
                Text("년")
            }
            
            HStack {
                Spacer()
                PensionBall(number: pension.winClass, unit: 0)
                Text("조")
                ForEach(Array(winNumber.enumerated()), id:\.offset) { (index, char) in
                    PensionBall(number: Int16(String(char)), unit: index+1)
                }
            }
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundGray.opacity(0.9))
            }
            
            Divider()
        }
    }
    
    private var winner2nd: some View {
        VStack(spacing: 5) {
            HStack(spacing: 0) {
                Text("2등")
                    .bold()
                Spacer()
                Text("월 ")
                Text("100")
                    .bold()
                Text("만원 X ")
                Text("10")
                    .bold()
                Text("년")
            }
            
            HStack {
                Spacer()
                ForEach(Array(winNumber.enumerated()), id:\.offset) { (index, char) in
                    PensionBall(number: Int16(String(char)), unit: index+1)
                }
            }
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundGray.opacity(0.9))
            }
            
            Divider()
        }
    }
    
    private var winner3rd: some View {
        VStack(spacing: 5) {
            HStack(spacing: 0) {
                Text("3등")
                    .bold()
                Spacer()
                Text("1백만원")
            }
            
            HStack {
                Spacer()
                ForEach(Array(winNumber.enumerated()), id:\.offset) { (index, char) in
                    if index > 0 {
                        PensionBall(number: Int16(String(char)), unit: index+1)
                    }
                }
            }
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundGray.opacity(0.9))
            }
            
            Divider()
        }
    }
    
    private var winner4th: some View {
        VStack(spacing: 5) {
            HStack(spacing: 0) {
                Text("4등")
                Spacer()
                Text("1십만원")
            }
            
            HStack {
                Spacer()
                ForEach(Array(winNumber.enumerated()), id:\.offset) { (index, char) in
                    if index > 1 {
                        PensionBall(number: Int16(String(char)), unit: index+1)
                    }
                }
            }
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundGray.opacity(0.9))
            }
            
            Divider()
        }
    }
    
    private var winner5th: some View {
        VStack(spacing: 5) {
            HStack(spacing: 0) {
                Text("5등")
                Spacer()
                Text("5만원")
            }
            
            HStack {
                Spacer()
                ForEach(Array(winNumber.enumerated()), id:\.offset) { (index, char) in
                    if index > 2 {
                        PensionBall(number: Int16(String(char)), unit: index+1)
                    }
                }
            }
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundGray.opacity(0.9))
            }
            
            Divider()
        }
    }
    
    private var winner6th: some View {
        VStack(spacing: 5) {
            HStack(spacing: 0) {
                Text("6등")
                Spacer()
                Text("5천원")
            }
            
            HStack {
                Spacer()
                ForEach(Array(winNumber.enumerated()), id:\.offset) { (index, char) in
                    if index > 3 {
                        PensionBall(number: Int16(String(char)), unit: index+1)
                    }
                }
            }
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundGray.opacity(0.9))
            }
            
            Divider()
        }
    }
    
    private var winner7th: some View {
        VStack(spacing: 5) {
            HStack(spacing: 0) {
                Text("7등")
                Spacer()
                Text("1천원")
            }
            
            HStack {
                Spacer()
                ForEach(Array(winNumber.enumerated()), id:\.offset) { (index, char) in
                    if index > 4 {
                        PensionBall(number: Int16(String(char)), unit: index+1)
                    }
                }
            }
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundGray.opacity(0.9))
            }
            
            Divider()
        }
    }
    
    private var winnerBonus: some View {
        VStack(spacing: 5) {
            HStack(spacing: 0) {
                Text("보너스")
                    .bold()
                Spacer()
                Text("월 ")
                Text("100")
                    .bold()
                Text("만원 X ")
                Text("10")
                    .bold()
                Text("년")
            }
            
            HStack {
                Spacer()
                Text("각 조")
                ForEach(Array(bonusNumber.enumerated()), id:\.offset) { (index, char) in
                    PensionBall(number: Int16(String(char)), unit: index+1)
                }
            }
            .padding(6)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.backgroundGray.opacity(0.9))
            }
        }
    }
    
}

//struct PensionResultDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        PensionResultDetail()
//    }
//}
