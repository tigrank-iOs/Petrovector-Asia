//
//  CalculationModel+CoreDataProperties.swift
//  
//
//  Created by Тигран on 24/10/2018.
//
//

import Foundation
import CoreData


extension CalculationModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalculationModel> {
        return NSFetchRequest<CalculationModel>(entityName: "CalculationModel")
    }

    @NSManaged public var autoRate: Double
    @NSManaged public var density80: Double
    @NSManaged public var density92: Double
    @NSManaged public var density95: Double
    @NSManaged public var densityDT: Double
    @NSManaged public var dieselDuty: Double
    @NSManaged public var ecologicalRate: Double
    @NSManaged public var elnurRate: Double
    @NSManaged public var exchangeRate: Double
    @NSManaged public var petrolDuty: Double
    @NSManaged public var railwayRate: Double
    @NSManaged public var vat: Double

}
