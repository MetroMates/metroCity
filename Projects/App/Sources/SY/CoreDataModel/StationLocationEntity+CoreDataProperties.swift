//
//  StationLocationEntity+CoreDataProperties.swift
//  
//
//  Created by 박서연 on 2023/11/29.
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
    @NSManaged public var route: String
    @NSManaged public var statnId: Int32
    @NSManaged public var statnNm: String
    @NSManaged public var id: String?

}
