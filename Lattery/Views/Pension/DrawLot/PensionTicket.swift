//
//  PensionTicket.swift
//  Lattery
//
//  Created by dodor on 2023/07/31.
//

import SwiftUI

struct PensionTicket: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var data: PensionData
    @Binding var show: Bool
    @State private var isSaved: Bool = false
    private let verticalPadding: CGFloat = 15
    private let now = Date()
    
    var body: some View {
        ZStack {
            Color.customGray
                .opacity(0.7)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .bottom, spacing: 0) {
                    Image("LatteryLogo")
                        .resizable()
                        .scaledToFit()
                    Text("연금복권720+")
                        .bold()
                        .padding(.leading, 2)
                    
                    Spacer()
                    
                    Button {
                        isSaved.toggle()
                    } label: {
                        Image(systemName: isSaved ? "heart.fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.customRed)
                            .shadow(color: .customRed, radius: isSaved ? 5 : 0)
                    }
                }
                .frame(height: 30)
                
                Text("발행일: \(now.toDateTimeString)")
                    .kerning(1.5)
                    .foregroundColor(.customGray)
                    .padding(.vertical, verticalPadding)
                    .font(.callout)
                Text("추첨일: \(now.nextThursday.toDateStringSlash)")
                    .kerning(1.5)
                    .foregroundColor(.customGray)
                    .font(.callout)
                
                Divider()
                    .padding(.vertical, verticalPadding)
                
                if data.pensionGroup == .allGroup {
                    ForEach(1...5, id:\.self) { number in
                        PensionTicketRow(numbers: [Int16(number)] + data.numberGroupForAll)
                            .padding(.bottom, verticalPadding)
                    }
                } else {
                    ForEach(data.numberGroupsForEach, id:\.self) { numbers in
                        PensionTicketRow(numbers: numbers)
                            .padding(.bottom, verticalPadding)
                    }
                }
                
                Divider()
                    .padding(.bottom, verticalPadding)
                
                Button {
                    if isSaved {
                        savePensionResult()
                    }
                    show.toggle()
                } label: {
                    Text("확인")
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(25)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(uiColor: .systemBackground))
            }
            .frame(maxWidth: 400)
            .padding()
        }
    }
    
    private func savePensionResult() {
        let result = PensionResult(context: moc)
        result.date = now
        result.lotteryDate = now.nextThursday.toDateStringSlash
        if data.pensionGroup == .allGroup {
            result.numbers1 = "1\(data.numberGroupForAll.map { String($0) }.joined(separator: ""))"
            result.numbers2 = "2\(data.numberGroupForAll.map { String($0) }.joined(separator: ""))"
            result.numbers3 = "3\(data.numberGroupForAll.map { String($0) }.joined(separator: ""))"
            result.numbers4 = "4\(data.numberGroupForAll.map { String($0) }.joined(separator: ""))"
            result.numbers5 = "5\(data.numberGroupForAll.map { String($0) }.joined(separator: ""))"
        } else {
            let count = data.numberGroupsForEach.count
            if count > 0 { result.numbers1 = data.numberGroupsForEach[0].map { String($0) }.joined(separator: "") }
            if count > 1 { result.numbers2 = data.numberGroupsForEach[1].map { String($0) }.joined(separator: "") }
            if count > 2 { result.numbers3 = data.numberGroupsForEach[2].map { String($0) }.joined(separator: "") }
            if count > 3 { result.numbers4 = data.numberGroupsForEach[3].map { String($0) }.joined(separator: "") }
            if count > 4 { result.numbers5 = data.numberGroupsForEach[4].map { String($0) }.joined(separator: "") }
        }

        PersistenceController.shared.save()
    }
}

struct PensionTicket_Previews: PreviewProvider {
    static var previews: some View {
        PensionTicket(show: .constant(true))
    }
}
