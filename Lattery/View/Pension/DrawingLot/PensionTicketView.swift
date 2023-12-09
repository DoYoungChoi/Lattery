//
//  PensionTicketView.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct PensionTicketView: View {
    
    @ObservedObject var viewModel: PensionDrawingLotViewModel
    
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
                        Text("연금복권720+")
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
                        .padding(.bottom, 16)
                    
                    ForEach(viewModel.drawingLotResult, id:\.self) { numbers in
                        PensionTicketRow(numbers: numbers)
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

private struct PensionTicketRow: View {
    
    let numbers: [Int?]
    
    fileprivate init(numbers: [Int?]) {
        self.numbers = numbers
    }
    
    fileprivate var body: some View {
        HStack(spacing: 0) {
            Spacer()
            ForEach(Array(numbers.enumerated()), id:\.offset) { (position, number) in
                if position == 0 {
                    Text("\(number ?? 0)조")
                        .font(.headline)
                } else {
                    Text("\(String(format: "%02d", number ?? 0))")
                        .font(.body)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    let viewModel: PensionDrawingLotViewModel = .init()
    viewModel.send(action: .run)
    
    return PensionTicketView(viewModel: viewModel)
}
