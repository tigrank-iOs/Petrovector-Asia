//
//  CountModel+CoreDataProperties.swift
//  
//
//  Created by Тигран on 25/10/2018.
//
//

import Foundation
import CoreData


extension CountModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountModel> {
        return NSFetchRequest<CountModel>(entityName: "CountModel")
    }

    @NSManaged public var azsType: String?
    @NSManaged public var conversion: Double
    @NSManaged public var dayOfWeek: String?
    @NSManaged public var enterCars: Int16
    @NSManaged public var latitude: Float
    @NSManaged public var longitude: Float
    @NSManaged public var month: Int16
    @NSManaged public var name: String?
    @NSManaged public var passedCars: Int16
    @NSManaged public var timeStart: Double
    @NSManaged public var timeStop: Double
    @NSManaged public var forecasts: NSSet?

}

// MARK: Generated accessors for forecasts
extension CountModel {

    @objc(addForecastsObject:)
    @NSManaged public func addToForecasts(_ value: Forecast)

    @objc(removeForecastsObject:)
    @NSManaged public func removeFromForecasts(_ value: Forecast)

    @objc(addForecasts:)
    @NSManaged public func addToForecasts(_ values: NSSet)

    @objc(removeForecasts:)
    @NSManaged public func removeFromForecasts(_ values: NSSet)

}
