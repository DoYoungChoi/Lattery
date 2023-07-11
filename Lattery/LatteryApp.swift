//
//  LatteryApp.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import SwiftUI

@main
struct LatteryApp: App {
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
