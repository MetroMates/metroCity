//
//  StationInfoEntity+CoreDataProperties.swift
//  
//
//  Created by 박서연 on 2023/11/29.
//
//

import Foundation
import CoreData

extension StationInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StationInfoEntity> {
        return NSFetchRequest<StationInfoEntity>(entityName: "StationInfoEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var statnId: Int32
    @NSManaged public var statnNm: String
    @NSManaged public var subwayId: Int32
    @NSManaged public var subwayNm: String

}
