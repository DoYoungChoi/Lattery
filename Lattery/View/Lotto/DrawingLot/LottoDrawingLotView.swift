//
//  LottoDrawingLotView.swift
//  Lattery
//
//  Created by dodor on 12/4/23.
//

import SwiftUI
import UIKit

struct LottoDrawingLotView: View {
    @EnvironmentObject private var services: Service
    
    @StateObject var viewModel: LottoDrawingLotViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                ForEach(LottoGroup.allCases) { group in
                    LottoRow(group: group,
                             numbers: viewModel.drawingLotResult[group] ?? .init(numbers: [])) {
                        viewModel.send(action: .toggleNumberSheet(group))
                    }
                }
                
                PawButtonPicker(viewModel: viewModel)
                
                PawButton(type: viewModel.paw) {
                    viewModel.send(action: .run)
                }
                .opacity(viewModel.isRunning ? 0.5 : 1)
                .scaleEffect(viewModel.isRunning ? 0.95 : 1)
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
                    .disabled(viewModel.showTicket)
                    
                    Button {
                        viewModel.send(action: .refresh)
                    } label: {
                        Image("refresh")
                    }
                    .disabled(viewModel.showTicket)
                }
            }
            .disabled(viewModel.isRunning)
            .sheet(isPresented: $viewModel.showNumberSheet) {
                LottoNumberSheet(viewModel: .init(services: services),
                                 fixedNumbers: $viewModel.drawingLotResult[viewModel.group])
            }
            
            if viewModel.showTicket {
                LottoTicketView(viewModel: viewModel)
                    .ignoresSafeArea(edges: .vertical)
            }
        }
        .onDisappear {
            viewModel.send(action: .disappear)
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
        LottoDrawingLotView(viewModel: .init(services: StubService()))
    }
}
