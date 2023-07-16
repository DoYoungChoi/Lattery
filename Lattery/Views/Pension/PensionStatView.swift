//
//  PensionStatView.swift
//  Lattery
//
//  Created by dodor on 2023/07/05.
//

import SwiftUI

let lastestPensionKey: String = "Pension"

struct PensionStatView: View {
    @EnvironmentObject var data: PensionData
    @State private var isFetching: Bool = false
    @State private var pensions: [Pension] = []
//    @AppStorage(lastestPensionKey) private var lastestPension: Int = 0
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    ForEach(pensions) { pension in
                        HStack {
                            ForEach(pension.rows2, id:\.rank) { row in
                                if row.rank == "1" {
                                    Text("\(row.round)회")
                                    Text("\(row.pensionDrawDate)")
                                    Text("\(row.rankClass)조")
                                    Text("\(row.rankNo)")
                                }
                            }
                            
//                            ForEach(pension.row1, id:\.rank) { row in
//                                Text("보너스: \(row.rankNo)")
//                            }
                        }
                    }
                }
            }
            
            if isFetching {
                LoadingView()
            }
        }
        .task {
            fetchLastestPensionData()
        }
    }
    
    private func fetchLastestPensionData() {
        isFetching.toggle()
        var keepGoing: Bool = true
        var lastestPension = 0
        
        Task {
            while (keepGoing) {
                do {
                    let pension = try await data.fetchData(lastestPension + 1)
                        lastestPension += 1
                    pensions.append(pension)
                    
                    if lastestPension == 10 {
                        keepGoing = false
                    }
                } catch {
                    print(error)
                    keepGoing = false
                }
            }
            
            isFetching.toggle()
        }
    }
}

struct PensionStatView_Previews: PreviewProvider {
    static var previews: some View {
        PensionStatView()
    }
}
