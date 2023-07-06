//
//  LatteryApp.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import SwiftUI

@main
struct LatteryApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
