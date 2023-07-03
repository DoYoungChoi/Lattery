//
//  ContentView.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var data = DrawingLotData()
    
    var body: some View {
        DrawingLotView()
            .environmentObject(data)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
