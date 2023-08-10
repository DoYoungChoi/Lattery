//
//  LottoNumberCheckRow.swift
//  Lattery
//
//  Created by dodor on 2023/08/10.
//

import SwiftUI

struct LottoNumberCheckRow: View {
    var lottoWin: LottoWin
    var numberString: String
    private var numbers: [Int16] {
        numberString.split(separator: ",").map { Int16($0) ?? 0 }
    }
    private var rank: String {
        let include: [Int16] = numbers.filter({ lottoWin.numbers.contains($0) })
        if include.count == 6 {
            return "1등 당첨"
        } else if include.count == 5 && numbers.contains(lottoWin.bonus) {
            return "2등 당첨"
        } else if include.count == 5 {
            return "3등 당첨"
        } else if include.count == 4 {
            return "4등 당첨"
        } else if include.count == 3 {
            return "5등 당첨"
        } else {
            return "낙첨"
        }
    }
    
    var body: some View {
        HStack {
            Spacer()
            Text(rank)
                .bold()
            Spacer()
            HStack {
                ForEach(numbers, id:\.self) { number in
                    LottoBall(number: number,
                              isSelected: lottoWin.numbers.contains(number))
                }
            }
            .padding(.horizontal)
        }
    }
}

struct LottoNumberCheckRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LottoNumberCheckRow(lottoWin: LottoWin.example,
                                numberString: "1,11,21,31,41,45")
            LottoNumberCheckRow(lottoWin: LottoWin.example,
                                numberString: "1,9,11,21,31,41")
            LottoNumberCheckRow(lottoWin: LottoWin.example,
                                numberString: "1,8,11,21,31,41")
            LottoNumberCheckRow(lottoWin: LottoWin.example,
                                numberString: "1,8,9,11,21,31")
            LottoNumberCheckRow(lottoWin: LottoWin.example,
                                numberString: "1,9,11,21,30,35")
            LottoNumberCheckRow(lottoWin: LottoWin.example,
                                numberString: "1,9,12,22,32,45")
        }
    }
}
