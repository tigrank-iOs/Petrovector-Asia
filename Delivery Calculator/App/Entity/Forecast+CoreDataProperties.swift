//
//  Forecast+CoreDataProperties.swift
//  
//
//  Created by Тигран on 25/10/2018.
//
//

import Foundation
import CoreData


extension Forecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Forecast> {
        return NSFetchRequest<Forecast>(entityName: "Forecast")
    }

    @NSManaged public var fuel: Int16
    @NSManaged public var value: Double
    @NSManaged public var countModel: CountModel?

}
