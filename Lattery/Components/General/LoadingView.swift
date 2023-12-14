//
//  LoadingView.swift
//  Lattery
//
//  Created by dodor on 12/6/23.
//

import SwiftUI

enum FetchType {
    case lotto
    case pension
}

@MainActor
struct LoadingView: View {
    
    @EnvironmentObject private var services: Service
    @State private var percent: Int = 0
    @Binding var phase: Phase
    var work: FetchType
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
            
            if phase == .loading {
                VStack(spacing: 12) {
                    progressBar
                    if #available(iOS 16.1, *) {
                        Text("Loading...")
                            .bold()
                            .fontDesign(.monospaced)
                    } else {
                        Text("Loading...")
                            .bold()
                    }
                }
                .font(.system(size: 16))
                .foregroundStyle(Color.white)
                .padding(.bottom, 20)
            } else if phase == .fail {

            }
        }
        .ignoresSafeArea()
        .task {
            switch work {
            case .lotto:
                await fetchLotto()
            case .pension:
                await fetchPension()
            }
        }
    }
    
}

extension LoadingView {
    
    private func fetchLotto() async {
        var round = 1
        var standard: TimeInterval = 1
        if let first = services.lottoService.getLottoEntity(round: 1) {
            standard = -first.date.timeIntervalSinceNow / (24 * 60 * 60)
            round = 2
        }
        
        var results: [LottoResult] = []
        var diffDays: TimeInterval = 0
        var isContinued: Bool = true
        while isContinued {
            let entity = services.lottoService.getLottoEntity(round: round)
            if let entity {
                // 이미 entity가 있는 경우는 다음 회차로 넘기기
                diffDays = -entity.date.timeIntervalSinceNow / (24 * 60 * 60)
            } else {
                // entity가 없으므로 동행복권에서 가져와서 넣기
                do {
                    let result = try await services.lottoService.getLottoObject(round: round)
                    diffDays = -result.date.timeIntervalSinceNow / (24 * 60 * 60)
                    results.append(result)
                } catch {
                    print("Fetch Lotto ERROR: \(error.localizedDescription)")
                    break
                }
            }
            
            if diffDays > standard { standard = diffDays }
            if diffDays < 7 {
                isContinued = false
            } else {
                round += 1
            }
            self.percent = Int((standard - diffDays) / standard * 100)
        }
        
        do {
            try services.lottoService.addLottoEntities(by: results)
            self.percent = 100
            if !isContinued {
                self.phase = .success
            } else {
                self.phase = .fail
            }
        } catch {
            print("Add Lotto Entities ERROR: \(error.localizedDescription)")
            self.percent = 100
            self.phase = .fail
        }
    }
    
    private func fetchPension() async {
        var round = 1
        var standard: TimeInterval = 1
        if let first = services.pensionService.getPensionEntity(round: 1) {
            standard = -first.date.timeIntervalSinceNow / (24 * 60 * 60)
            round = 2
        }
        
        var results: [PensionResult] = []
        var diffDays: TimeInterval = 0
        var isContinued: Bool = true
        while isContinued {
            let entity = services.pensionService.getPensionEntity(round: round)
            if let entity {
                // 이미 entity가 있는 경우는 다음 회차로 넘기기
                diffDays = -entity.date.timeIntervalSinceNow / (24 * 60 * 60)
            } else {
                // entity가 없으므로 동행복권에서 가져와서 넣기
                do {
                    let result = try await services.pensionService.getPensionObject(round: round)
                    diffDays = -result.date.timeIntervalSinceNow / (24 * 60 * 60)
                    results.append(result)
                } catch {
                    print("Fetch Pension ERROR: \(error.localizedDescription)")
                    break
                }
            }
            
            if diffDays > standard { standard = diffDays }
            if diffDays < 7 {
                isContinued = false
            } else {
                round += 1
            }
            self.percent = Int((standard - diffDays) / standard * 100)
        }
        
        do {
            try services.pensionService.addPensionEntities(by: results)
            self.percent = 100
            if !isContinued {
                self.phase = .success
            } else {
                self.phase = .fail
            }
        } catch {
            print("Add Pension Entities ERROR: \(error.localizedDescription)")
            self.percent = 100
            self.phase = .fail
        }
    }
}

extension LoadingView {
    
    var progressBar: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.accentColor)
                .frame(width: CGFloat(130 * percent / 100), height: 8)
                .padding(.horizontal, 2)
            
            RoundedRectangle(cornerRadius: 3)
                .stroke(Color.white, lineWidth: 3)
        }
        .frame(width: 130, height: 14)
    }
}

#Preview {
    LoadingView(phase: .constant(.fail), work: .lotto)
        .environmentObject(StubService())
}
