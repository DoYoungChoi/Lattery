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
    @State private var ascending: Bool = false // descending
    
    var body: some View {
        List {
            HStack {
                Rectangle()
                    .frame(width: 5)
                    .foregroundColor(.backgroundGray)
                
                Toggle("회차 오름차순", isOn: $ascending)
                    .tint(.customPink)
            }
            
            ForEach(pensions) { pension in
                NavigationLink {
                    PensionResultDetail(pension: pension)
                } label: {
                    PensionResultRow(pension: pension)
                }
            }
        }
        .listStyle(.inset)
        .onChange(of: ascending) { newValue in
            let order: SortOrder = newValue ? .forward : .reverse
            pensions.sortDescriptors = [SortDescriptor(\.round, order: order)]
        }
    }
}

struct PensionResultList_Previews: PreviewProvider {
    static var previews: some View {
        PensionResultList()
    }
}
