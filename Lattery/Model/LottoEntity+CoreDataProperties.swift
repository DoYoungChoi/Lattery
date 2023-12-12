//
//  LottoEntity+CoreDataProperties.swift
//  Lattery
//
//  Created by dodor on 12/10/23.
//
//

import Foundation
import CoreData


extension LottoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LottoEntity> {
        return NSFetchRequest<LottoEntity>(entityName: "LottoEntity")
    }

    @NSManaged public var round: Int16
    @NSManaged public var date: Date
    @NSManaged public var numbers: [Int]
    @NSManaged public var bonus: Int16
    @NSManaged public var winnings: Int64
    @NSManaged public var totalSalePrice: Int64
    @NSManaged public var winnerCount: Int16

}

extension LottoEntity : Identifiable {
    public var id: Int16 { round }
}
