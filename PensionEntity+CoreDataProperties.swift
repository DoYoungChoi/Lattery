//
//  PensionEntity+CoreDataProperties.swift
//  Lattery
//
//  Created by dodor on 12/13/23.
//
//

import Foundation
import CoreData


extension PensionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PensionEntity> {
        return NSFetchRequest<PensionEntity>(entityName: "PensionEntity")
    }

    @NSManaged public var round: Int16
    @NSManaged public var date: Date
    @NSManaged public var numbers: String
    @NSManaged public var bonus: String

}

extension PensionEntity : Identifiable {

}
