//
//  LottoTicketView.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import SwiftUI

struct LottoTicketView: View {
    
    @ObservedObject var viewModel: LottoDrawingLotViewModel
    
    var body: some View {
        ZStack {
            Color.primaryColor.opacity(0.3)
            
            HStack(spacing: 0) {
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .bottom, spacing: 8) {
                        Image("paw")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(.customPink)
                        Text("로또 6/45")
                            .font(.headline)
                        Spacer()
                        Button {
                            viewModel.send(action: .toggleSave)
                        } label: {
                            HeartIcon(checked: viewModel.save)
                        }
                    }
                    
                    Text("발행일: \(Date().toDateTimeString)")
                        .foregroundStyle(Color.gray2)
                    
                    Divider()
                    
                    ForEach(viewModel.drawingLotResult.keys.sorted()) { group in
                        LottoTicketRow(group: group.id,
                                       numbers: viewModel.drawingLotResult[group]!)
                    }
                    
                    Divider()
                    
                    Button {
                        viewModel.send(action: .toggleTicket)
                    } label: {
                        HStack {
                            Spacer()
                            Text("확인")
                            Spacer()
                        }
                        .padding(.bottom, 16)
                    }
                    .clipShape(Rectangle())
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .background(Color.pureBackground)
                .frame(maxWidth: 360)
                .cornerRadius(10)
                
                Spacer()
            }
        }
    }
}

private struct LottoTicketRow: View {
    
    let group: String
    let numbers: LottoNumbers
    
    fileprivate init(group: String,
                     numbers: LottoNumbers) {
        self.group = group
        self.numbers = numbers
    }
    
    fileprivate var body: some View {
        HStack(spacing: 0) {
            Spacer()
            Text(group)
                .font(.headline)
            Spacer()
            ForEach(numbers.numbers, id:\.self) { number in
                Text("\(String(format: "%02d", number))")
                    .font(.body)
                Spacer()
            }
        }
    }
}

#Preview {
    let viewModel: LottoDrawingLotViewModel = .init()
    viewModel.send(action: .run)
    
    return LottoTicketView(viewModel: viewModel)
}
