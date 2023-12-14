//
//  LatteryApp.swift
//  Lattery
//
//  Created by dodor on 2023/07/03.
//

import SwiftUI

@main
struct LatteryApp: App {
    @StateObject private var services = Service()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(services)
        }
    }
}
