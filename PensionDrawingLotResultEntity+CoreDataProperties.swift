//
//  PensionDrawingLotResultEntity+CoreDataProperties.swift
//  Lattery
//
//  Created by dodor on 12/13/23.
//
//

import Foundation
import CoreData


extension PensionDrawingLotResultEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PensionDrawingLotResultEntity> {
        return NSFetchRequest<PensionDrawingLotResultEntity>(entityName: "PensionDrawingLotResultEntity")
    }

    @NSManaged public var date: Date
    @NSManaged public var data: [String]
    @NSManaged public var id: String

}

extension PensionDrawingLotResultEntity : Identifiable {

}
