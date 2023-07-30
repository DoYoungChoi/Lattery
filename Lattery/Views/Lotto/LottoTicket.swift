//
//  LottoTicket.swift
//  Lattery
//
//  Created by dodor on 2023/07/30.
//

import SwiftUI

struct LottoTicket: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var data: LottoData
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
                    Text("6/45")
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
                Text("추첨일: \(now.nextSatureday.toDateStringSlash)")
                    .kerning(1.5)
                    .foregroundColor(.latteGray)
                    
                Divider()
                    .padding(.vertical, verticalPadding)
                
                ForEach(LottoGroup.allCases) { group in
                    LottoTicketRow(group: group)
                        .padding(.bottom, verticalPadding)
                }
                
                Divider()
                    .padding(.bottom, verticalPadding)
                
                Button {
                    if isSaved {
                        saveLottoResult()
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
            .padding()
        }
    }
    
    private func saveLottoResult() {
        let result = LottoResult(context: moc)
        result.date = now
        result.lotteryDate = now.nextSatureday.toDateStringSlash
        result.aGroup = data.numberGroups[LottoGroup.a]?.map { String($0) }.joined(separator: ",")
        result.bGroup = data.numberGroups[LottoGroup.b]?.map { String($0) }.joined(separator: ",")
        result.cGroup = data.numberGroups[LottoGroup.c]?.map { String($0) }.joined(separator: ",")
        result.dGroup = data.numberGroups[LottoGroup.d]?.map { String($0) }.joined(separator: ",")
        result.eGroup = data.numberGroups[LottoGroup.e]?.map { String($0) }.joined(separator: ",")
        
        PersistenceController.shared.save()
    }
}

struct LottoTicket_Previews: PreviewProvider {
    static var previews: some View {
        LottoTicket(show: .constant(true))
            .environmentObject(LottoData())
    }
}
