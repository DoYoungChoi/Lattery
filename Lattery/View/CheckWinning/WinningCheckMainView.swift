//
//  CheckWinningMainView.swift
//  Lattery
//
//  Created by dodor on 12/7/23.
//

import SwiftUI

struct WinningCheckMainView: View {
    
    @EnvironmentObject private var services: Service
    
    @State private var phase: Phase = .notRequested
    @State private var type: LotteryType = .lotto
    enum LotteryType: String, Identifiable, CaseIterable {
        case lotto = "로또 6/45"
        case pension = "연금복권720+"
        
        var id: String { rawValue }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                LotteryPagePicker(type: $type)
                
                switch type {
                case .lotto:
                    LottoWinningCheckView(viewModel: .init(services: services),
                                          phase: $phase)
                case .pension:
                    PensionWinningCheckView(viewModel: .init(services: services),
                                            phase: $phase)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .navigationTitle("추첨결과 확인")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        phase = .loading
                    } label: {
                        Image("refresh")
                    }
                }
            }
            
            if phase == .loading {
                LoadingView(phase: $phase,
                            work: type == .lotto ? .lotto : .pension)
            }
        }
    }
}

private struct LotteryPagePicker: View {
    @Binding var type: WinningCheckMainView.LotteryType
    
    fileprivate var body: some View {
        HStack {
            ForEach(WinningCheckMainView.LotteryType.allCases) { type in
                Button(type.id) {
                    self.type = type
                }
                .buttonStyle(PickerButtonStyle(isSelected: self.type == type))
            }
        }
    }
}

#Preview {
    WinningCheckMainView()
}
