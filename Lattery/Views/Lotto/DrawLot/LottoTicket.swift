
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
            Color.customGray
                .opacity(0.7)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .bottom, spacing: 0) {
                    Image("paw_pink")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                    Text("Lotto6/45")
                        .bold()
                        .padding(.leading, 2)
                    
                    Spacer()
                    
                    Button {
                        isSaved.toggle()
                    } label: {
                        Image(isSaved ? "heart_fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .shadow(color: .customRed, radius: isSaved ? 5 : 0)
                    }
                }
                
                Text("발행일: \(now.toDateTimeString)")
                    .kerning(1.5)
                    .foregroundColor(.accentColor)
                    .padding(.vertical, verticalPadding)
                    .font(.callout)
                Text("추첨일: \(now.nextSatureday.toDateStringSlash)")
                    .kerning(1.5)
                    .foregroundColor(.accentColor)
                    .font(.callout)
                    
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
                    Rectangle()
                        .fill(.background)
                        .overlay {
                            Text("확인")
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: 30, alignment: .center)
            }
            .padding(25)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(.background)
            }
            .frame(maxWidth: 400)
            .padding()
        }
    }
    
    private func saveLottoResult() {
        data.saveLottoResult(moc)
    }
}

struct LottoTicket_Previews: PreviewProvider {
    static var previews: some View {
        LottoTicket(show: .constant(true))
            .environmentObject(LottoData())
    }
}
