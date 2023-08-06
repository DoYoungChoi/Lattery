//
//  PagePicker.swift
//  Lattery
//
//  Created by dodor on 2023/08/06.
//

import SwiftUI

enum Page: String, CaseIterable, Identifiable {
    case detail = "지난회차정보"
    case stat = "통계"
    var id: String { rawValue }
}

struct PagePicker: View {
    @Binding var selection: Page
    
    var body: some View {
        HStack {
            ForEach(Page.allCases) { page in
                VStack(spacing: 0) {
                    Text(page.id)
                        .padding(.vertical, 10)
                    
                    Rectangle()
                        .frame(height: 3)
                        .foregroundColor(.customPink)
                        .opacity(selection == page ? 1 : 0)
                }
                .background(.background)
                .opacity(selection == page ? 1 : 0.3)
                .onTapGesture {
                    withAnimation {
                        selection = page
                    }
                }
            }
        }
    }
}

struct PagePicker_Previews: PreviewProvider {
    static var previews: some View {
        PagePicker(selection: .constant(.detail))
    }
}
