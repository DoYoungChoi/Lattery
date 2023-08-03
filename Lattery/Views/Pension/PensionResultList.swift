//
//  PensionResultList.swift
//  Lattery
//
//  Created by dodor on 2023/08/03.
//

import SwiftUI

struct PensionResultList: View {
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.round, order: .reverse)
    ]) var pensions: FetchedResults<PensionEntity>
    
    var body: some View {
        List {
            ForEach(pensions) { pension in
                let winNumber = pension.winNumbers ?? ""
                
                NavigationLink {
                    PensionResultDetail(pension: pension)
                } label: {
                    HStack {
                        Text(verbatim: "\(pension.round)회")
                        PensionBall(number: pension.winClass, unit: 0)
                        Text("조")
                        ForEach(Array(winNumber.enumerated()), id:\.offset) { (index, char) in
                            PensionBall(number: Int16(String(char)), unit: index+1)
                        }
                    }
                }
            }
        }
        .listStyle(.inset)
    }
}

struct PensionResultList_Previews: PreviewProvider {
    static var previews: some View {
        PensionResultList()
    }
}
