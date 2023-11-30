//
//  StationLocationEntity+CoreDataProperties.swift
//  
//
//  Created by woojin Shin on 2023/11/30.
//
//

import Foundation
import CoreData


extension StationLocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StationLocationEntity> {
        return NSFetchRequest<StationLocationEntity>(entityName: "StationLocationEntity")
    }

    @NSManaged public var crdntX: Double
    @NSManaged public var crdntY: Double
    @NSManaged public var id: String
    @NSManaged public var route: String
    @NSManaged public var statnId: Int32
    @NSManaged public var statnNm: String

}
