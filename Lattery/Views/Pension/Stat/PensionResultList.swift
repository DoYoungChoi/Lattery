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
                NavigationLink {
                    PensionResultDetail(pension: pension)
                } label: {
                    PensionResultRow(pension: pension)
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
