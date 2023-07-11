//
//  LottoStatView.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import SwiftUI

let lastestLottoKey: String = "Lotto"

struct LottoStatView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var data: LottoData
    @State private var isFetching: Bool = false
    @AppStorage(lastestLottoKey) private var lastestLotto: Int = 0
    @State private var page: Page = .detail
    private enum Page: String, CaseIterable, Identifiable {
        case detail = "회차정보"
        case total = "총횟수"
        case colorPersent = "차지율"
        var id: String { rawValue }
    }
    
    var body: some View {
        ZStack {
            VStack {
                // 최신 로또 당첨 결과
                LastestLottoResult()
                    .redacted(reason: isFetching ? .placeholder : [])
                
                // 통계 페이지
                Picker("페이지", selection: $page) {
                    ForEach(Page.allCases) { page in
                        Text(page.rawValue)
                            .tag(page)
                    }
                }
                .pickerStyle(.segmented)
                
                if page == .detail {
                    LottoResultList()
                } else if page == .total {
                    LottoGraph()
                } else if page == .colorPersent {
                    
                }
                
                Spacer()
            }
            
            if isFetching {
                LoadingView()
            }
        }
        .navigationTitle("로또 통계")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    fetchLastLottoData()
                } label: {
                    Label("발바닥", systemImage: isFetching ? "pawprint" : "pawprint.fill")
                }
            }
        }
        .task {
            fetchLastLottoData()
        }
    }
    
    private func fetchLastLottoData() {
        isFetching.toggle()
        var keepGoing: Bool = true
        
        Task {
            while (keepGoing) {
                do {
                    let lotto = try await data.fetchData(lastestLotto + 1)
                    if let _ = lotto.toEntity(context: moc) {
                        lastestLotto += 1
                    } else {
                        keepGoing = false
                    }
                } catch {
                    print(error)
                    keepGoing = false
                }
            }
            
            PersistenceController.shared.save()
            isFetching.toggle()
        }
    }
}

//struct LottoStatView_Previews: PreviewProvider {
//    static var previews: some View {
//        LottoStatView()
//    }
//}
