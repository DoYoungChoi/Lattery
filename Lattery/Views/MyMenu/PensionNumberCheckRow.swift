//
//  PensionNumberCheckRow.swift
//  Lattery
//
//  Created by dodor on 2023/08/10.
//

import SwiftUI

struct PensionNumberCheckRow: View {
    var numberString: String
    var winNumbers: String
    var bonusNumbers: String
    private var rankText: String {
        if rank == 1 {
            return "🥇1등🥇"
        } else if rank == 2 {
            return "🥈2등🥈"
        } else if rank == 3 {
            return "🥉3등🥉"
        } else if rank == 8 {
            return "🏅보너스🏅"
        } else if rank < 8 {
            return "\(rank)등"
        } else {
            return "낙첨"
        }
    }
    private var rank: Int {
        guard winNumbers.count == 7 && bonusNumbers.count == 6 && numberString.count == 7 else { return 9 }
        
        if winNumbers == numberString {
            return 1
        }
        var index = winNumbers.index(winNumbers.startIndex, offsetBy: 1)
        if winNumbers.suffix(from: index) == numberString.suffix(from: index) {
            return 2
        }
        if bonusNumbers == numberString.suffix(from: index) {
            return 8
        }
        index = winNumbers.index(winNumbers.startIndex, offsetBy: 2)
        if winNumbers.suffix(from: index) == numberString.suffix(from: index) {
            return 3
        }
        index = winNumbers.index(winNumbers.startIndex, offsetBy: 3)
        if winNumbers.suffix(from: index) == numberString.suffix(from: index) {
            return 4
        }
        index = winNumbers.index(winNumbers.startIndex, offsetBy: 4)
        if winNumbers.suffix(from: index) == numberString.suffix(from: index) {
            return 5
        }
        index = winNumbers.index(winNumbers.startIndex, offsetBy: 5)
        if winNumbers.suffix(from: index) == numberString.suffix(from: index) {
            return 6
        }
        index = winNumbers.index(winNumbers.startIndex, offsetBy: 6)
        if winNumbers.suffix(from: index) == numberString.suffix(from: index) {
            return 7
        }
        return 9
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(rankText)
                .bold()
                .lineLimit(1)
                .font(.headline)
                .padding(.leading)
            
            HStack {
                Spacer()
                ForEach(Array(numberString.enumerated()), id:\.offset) { (index, char) in
                    PensionBall(number: Int16(String(char)),
                                unit: index,
                                isSelected: index+1 >= rank)
                    
                    if index == 0 {
                        Text("조")
                    }
                }
            }
            .padding(.trailing, 1)
        }
    }
}

struct PensionNumberCheckRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PensionNumberCheckRow(numberString: "2965178",
                                  winNumbers: "2965178",
                                  bonusNumbers: "037262")
            
            PensionNumberCheckRow(numberString: "1965178",
                                  winNumbers: "2965178",
                                  bonusNumbers: "037262")
            
            PensionNumberCheckRow(numberString: "2165178",
                                  winNumbers: "2965178",
                                  bonusNumbers: "037262")
            
            PensionNumberCheckRow(numberString: "2115178",
                                  winNumbers: "2965178",
                                  bonusNumbers: "037262")
            
            PensionNumberCheckRow(numberString: "2111178",
                                  winNumbers: "2965178",
                                  bonusNumbers: "037262")
            
            PensionNumberCheckRow(numberString: "2111278",
                                  winNumbers: "2965178",
                                  bonusNumbers: "037262")
            
            PensionNumberCheckRow(numberString: "2111218",
                                  winNumbers: "2965178",
                                  bonusNumbers: "037262")
            
            PensionNumberCheckRow(numberString: "2037262",
                                  winNumbers: "2965178",
                                  bonusNumbers: "037262")
            
            PensionNumberCheckRow(numberString: "2111210",
                                  winNumbers: "2965178",
                                  bonusNumbers: "037262")
        }
    }
}
