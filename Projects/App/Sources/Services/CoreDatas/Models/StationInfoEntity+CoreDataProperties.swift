//
//  StationInfoEntity+CoreDataProperties.swift
//  
//
//  Created by woojin Shin on 2023/11/30.
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
