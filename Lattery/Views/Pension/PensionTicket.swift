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
            Color.primary.opacity(0.5)
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
                        //                            .frame(width: 30, height: 30)
                            .foregroundColor(.latteRed)
                            .shadow(color: .latteRed, radius: isSaved ? 5 : 0)
                    }
                }
                .frame(height: 30)
                
                Text("발행일: \(now.toDateTimeString)")
                    .kerning(1.5)
                    .foregroundColor(.latteGray)
                    .padding(.vertical, verticalPadding)
                Text("추첨일: \(now.nextThursday.toDateStringSlash)")
                    .kerning(1.5)
                    .foregroundColor(.latteGray)
                
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
//        let result = LottoResult(context: moc)
//        result.date = now
//        result.lotteryDate = now.nextSatureday.toDateStringSlash
//        result.aGroup = data.numberGroups[LottoGroup.a]?.map { String($0) }.joined(separator: ",")
//        result.bGroup = data.numberGroups[LottoGroup.b]?.map { String($0) }.joined(separator: ",")
//        result.cGroup = data.numberGroups[LottoGroup.c]?.map { String($0) }.joined(separator: ",")
//        result.dGroup = data.numberGroups[LottoGroup.d]?.map { String($0) }.joined(separator: ",")
//        result.eGroup = data.numberGroups[LottoGroup.e]?.map { String($0) }.joined(separator: ",")
//
//        PersistenceController.shared.save()
    }
}

struct PensionTicket_Previews: PreviewProvider {
    static var previews: some View {
        PensionTicket(show: .constant(true))
    }
}
