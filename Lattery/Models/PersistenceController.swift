//
//  PersistenceController.swift
//  Lattery
//
//  Created by dodor on 2023/07/10.
//

import Foundation
import CoreData

struct PersistenceController {
    // A singleton for our entire app to use
    static let shared = PersistenceController()

    // Storage for Core Data
    let container: NSPersistentContainer

    // A test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)

        // Create 10 example programming languages.
        for i in 0..<10 {
            let lotto = LottoEntity(context: controller.container.viewContext)
            lotto.round = Int16(i + 1)
            lotto.no1 = (1..<5).randomElement()!
            lotto.no2 = (5..<11).randomElement()!
            lotto.no3 = (11..<21).randomElement()!
            lotto.no4 = (21..<31).randomElement()!
            lotto.no5 = (31..<41).randomElement()!
            lotto.no6 = (41..<46).randomElement()!
            lotto.noBonus = (1...45).randomElement()!
            lotto.date = Date(timeIntervalSinceNow: TimeInterval(-60 * 60 * 24 * 7 * i))
            lotto.winnerCount = Int16(20 - i)
            lotto.winnerReward = Int64(2_000_000_000 + i * 100_000_000)
        }

        return controller
    }()

    // An initializer to load Core Data, optionally able
    // to use an in-memory store.
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DataModel")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
            }
        }
    }
}
