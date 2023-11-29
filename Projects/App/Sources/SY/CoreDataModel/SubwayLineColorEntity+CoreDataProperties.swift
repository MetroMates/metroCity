//
//  SubwayLineColorEntity+CoreDataProperties.swift
//  
//
//  Created by woojin Shin on 2023/11/30.
//
//

import Foundation
import CoreData


extension SubwayLineColorEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubwayLineColorEntity> {
        return NSFetchRequest<SubwayLineColorEntity>(entityName: "SubwayLineColorEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var subwayId: Int32
    @NSManaged public var subwayNm: String
    @NSManaged public var lineColorHexCode: String

}
