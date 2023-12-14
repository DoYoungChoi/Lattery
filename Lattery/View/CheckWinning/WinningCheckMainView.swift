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
            } else if phase == .fail {
                AlertView(title: "데이터를 가져오는 중\n에러가 발생했습니다.",
                          content: "안정된 네트워크 환경에서\n다시 시도해주시기 바랍니다.") {
                    phase = .success
                }
            }
        }
    }
}

private struct LotteryPagePicker: View {
    @Binding var type: LotteryType
    
    fileprivate var body: some View {
        HStack {
            ForEach(LotteryType.allCases) { type in
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
