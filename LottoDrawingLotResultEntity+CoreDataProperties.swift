//
//  LottoDrawingLotResultEntity+CoreDataProperties.swift
//  Lattery
//
//  Created by dodor on 12/12/23.
//
//

import Foundation
import CoreData


extension LottoDrawingLotResultEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LottoDrawingLotResultEntity> {
        return NSFetchRequest<LottoDrawingLotResultEntity>(entityName: "LottoDrawingLotResultEntity")
    }

    @NSManaged public var date: Date
    @NSManaged public var data: [String]
    @NSManaged public var id: String

}

extension LottoDrawingLotResultEntity : Identifiable {

}
