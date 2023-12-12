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
    @StateObject private var services = Service(lottoService: LottoService(),
                                                pensionService: PensionService())
//    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(services)
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
//        .onChange(of: scenePhase) { _ in
//            persistenceController.save()
//        }
    }
}
