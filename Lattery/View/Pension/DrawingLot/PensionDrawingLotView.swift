//
//  PensionDrawingLotView.swift
//  Lattery
//
//  Created by dodor on 12/5/23.
//

import SwiftUI

struct PensionDrawingLotView: View {
    
    @StateObject var viewModel: PensionDrawingLotViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                ForEach(viewModel.drawingLotResult, id:\.self) { result in
                    PensionRow(numbers: result,
                               action: {
                        viewModel.send(action: .toggleNumberSheet)
                    })
                }
                
                PawButtonPicker(viewModel: viewModel)
                
                PawButton(type: viewModel.paw) {
                    viewModel.send(action: .run)
                }
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
                    
                    Button {
                        viewModel.send(action: .refresh)
                    } label: {
                        Image("refresh")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showNumberSheet) {
                PensionNumberSheet(viewModel: .init())
            }
            
            if viewModel.showTicket {
                PensionTicketView(viewModel: viewModel)
                    .ignoresSafeArea(edges: .vertical)
            }
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
        PensionDrawingLotView(viewModel: .init())
    }
}
