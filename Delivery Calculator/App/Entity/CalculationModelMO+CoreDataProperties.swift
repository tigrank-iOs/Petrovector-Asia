//
//  CalculationModelMO+CoreDataProperties.swift
//  
//
//  Created by Тигран on 23/10/2018.
//
//

import Foundation
import CoreData


extension CalculationModelMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalculationModelMO> {
        return NSFetchRequest<CalculationModelMO>(entityName: "CalculationModel")
    }

    @NSManaged public var exchangeRate: Double
    @NSManaged public var petrolDuty: Double
    @NSManaged public var dieselDuty: Double
    @NSManaged public var ecologicalRate: Double
    @NSManaged public var vat: Double
    @NSManaged public var railwayRate: Double
    @NSManaged public var autoRate: Double
    @NSManaged public var elnurRate: Double
    @NSManaged public var density80: Double
    @NSManaged public var density92: Double
    @NSManaged public var density95: Double
    @NSManaged public var densityDT: Double
    @NSManaged public var id: Int16

}
