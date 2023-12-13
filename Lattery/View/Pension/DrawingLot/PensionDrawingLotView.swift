//
//  PensionDrawingLotView.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct PensionDrawingLotView: View {
    
    @StateObject var viewModel: PensionDrawingLotViewModel
    private var disableSave: Bool {
        viewModel.drawingLotResult.count != 5
        || viewModel.drawingLotResult.map({ $0.numbers.filter({ $0 != nil }).count < 7 }).reduce(false) { $0 || $1 }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                ForEach(viewModel.drawingLotResult, id:\.self) { result in
                    PensionRow(numbers: result) {
                        viewModel.send(action: .toggleNumberSheet)
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
            .navigationTitle("연금복권 번호추첨")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        viewModel.send(action: .toggleSave)
                    } label: {
                        HeartIcon(checked: viewModel.save)
                    }
                    .disabled(disableSave)
                    
                    Button {
                        viewModel.send(action: .refresh)
                    } label: {
                        Image("refresh")
                    }
                }
            }
            .disabled(viewModel.isRunning || viewModel.showTicket)
            .sheet(isPresented: $viewModel.showNumberSheet) {
                if #available(iOS 16.0, *) {
                    PensionNumberSheet(fixedNumbers: $viewModel.fixedNumbers)
                        .presentationDetents([.fraction(0.7)])
                } else {
                    PensionNumberSheet(fixedNumbers: $viewModel.fixedNumbers)
                }
            }
            
            if viewModel.showTicket {
                PensionTicketView(viewModel: viewModel)
                    .ignoresSafeArea(edges: .vertical)
            }
        }
        .onDisappear {
            viewModel.send(action: .disappear)
        }
    }
}

private struct PawButtonPicker: View {
    
    @ObservedObject var viewModel: PensionDrawingLotViewModel
    
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
        PensionDrawingLotView(viewModel: .init(services: StubService()))
    }
}
