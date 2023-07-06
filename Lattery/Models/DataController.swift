//
//  DataController.swift
//  Lattery
//
//  Created by dodor on 2023/07/06.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "DataModel") // the data model in "DataModel".xcdatamodeld.
    // NSPersistentContainer, which is the Core Data type responsible for loading a data model and giving us access to the data inside.
    
    init() {
        // loadPersistentStores: This doesn’t load all the data into memory at the same time, because that would be wasteful, but at least Core Data can see all the information we have.
        // NSPersistentStoreContainer, which handles loading the actual data we have saved to the user’s device.
        // when you load objects and change them, those changes only exist in memory until you specifically save them back to the persistent store.
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
