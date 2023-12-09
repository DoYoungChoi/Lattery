//
//  LottoDrawingLotView.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import SwiftUI
import UIKit

struct LottoDrawingLotView: View {
    
    @StateObject var viewModel: LottoDrawingLotViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                ForEach(LottoGroup.allCases) { group in
                    LottoRow(group: group,
                             numbers: viewModel.drawingLotResult[group] ?? .init(numbers: [])) {
                        viewModel.send(action: .toggleNumberSheet)
                    }
                }
                
                PawButtonPicker(viewModel: viewModel)
                
                PawButton(type: viewModel.paw) {
                    viewModel.send(action: .run)
                }
            }
            .padding(.horizontal, 20)
            .navigationTitle("로또 번호추첨")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        viewModel.send(action: .toggleSave)
                    } label: {
                        HeartIcon(checked: viewModel.save)
                    }
                    
                    Button {
                        viewModel.send(action: .refresh)
                    } label: {
                        Image("refresh")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showNumberSheet) {
                LottoNumberSheet(viewModel: .init())
            }
            
            if viewModel.showTicket {
                LottoTicketView(viewModel: viewModel)
                    .ignoresSafeArea(edges: .vertical)
            }
        }
    }
}

private struct PawButtonPicker: View {
    
    @ObservedObject var viewModel: LottoDrawingLotViewModel
    
    fileprivate var body: some View {
        HStack(spacing: 0) {
            ForEach(Paw.allCases) { paw in
                Button(paw.id) {
                    viewModel.send(action: .changePaw(paw))
                }
                .buttonStyle(PickerButtonStyle(isSelected: viewModel.paw == paw))
            }
            .opacity(viewModel.showPicker ? 1 : 0)
            .padding(.trailing, 8)

            Button {
                viewModel.send(action: .toggleShowPicker)
            } label: {
                Image("paw")
                    .renderingMode(.template)
                    .foregroundColor(.accentColor)
            }
        }
    }
}

#Preview {
    NavigationView {
        LottoDrawingLotView(viewModel: .init())
    }
}
