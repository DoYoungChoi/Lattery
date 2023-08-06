//
//  LottoStatView.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import SwiftUI

struct LottoStatView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var data: LottoData
    @State private var isFetching: Bool = false
    @State private var page: Page = .detail
    
    var body: some View {
        VStack {
            // 최신 로또 당첨 결과
            LottoResultBoard()
                .redacted(reason: isFetching ? .placeholder : [])
            
            PagePicker(selection: $page)
                
            if page == .detail {
                LottoResultList()
                    .padding(.leading, -15)
            } else if page == .stat {
                LottoRatioGraphView()
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("로또 정보")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
//                    fetchLastestLottoData()
                } label: {
                    Image(systemName: "pawprint.fill")
                }
            }
        }
    }
    
//    private func fetchLastestLottoData() {
//        isFetching.toggle()
//        var keepGoing: Bool = true
//
//        Task {
//            while (keepGoing) {
//                do {
//                    let lotto = try await data.fetchData(lastestLotto + 1)
//                    if let _ = lotto.toEntity(context: moc) {
//                        lastestLotto += 1
//                    } else {
//                        keepGoing = false
//                    }
//                } catch {
//                    print(error)
//                    keepGoing = false
//                }
//            }
//
//            PersistenceController.shared.save()
//            isFetching.toggle()
//        }
//    }
}

//struct LottoStatView_Previews: PreviewProvider {
//    static var previews: some View {
//        LottoStatView()
//    }
//}
