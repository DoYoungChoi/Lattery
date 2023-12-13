//
//  LoadingView.swift
//  Lattery
//
//  Created by dodor on 12/6/23.
//

import SwiftUI

enum FetchWork {
    case lotto
    case pension
}

@MainActor
struct LoadingView: View {
    
    @EnvironmentObject private var services: Service
    @State private var percent: Int = 0
    @Binding var phase: Phase
    var work: FetchWork
    
    var body: some View {
        ZStack {
            Color.primaryColor.opacity(0.3)
            
            VStack {
                ProgressView()
                Text("loading")
                Text("\(percent) %")
            }
            .foregroundStyle(Color.pureBackground)
            .clipShape(Rectangle())
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
                    isContinued = false
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
            self.phase = .success
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
                    isContinued = false
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
            self.phase = .success
        } catch {
            print("Add Pension Entities ERROR: \(error.localizedDescription)")
            self.percent = 100
            self.phase = .fail
        }
    }
}

#Preview {
    LoadingView(phase: .constant(.loading), work: .lotto)
}
