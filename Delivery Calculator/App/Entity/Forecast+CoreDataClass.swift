//
//  Forecast+CoreDataClass.swift
//  
//
//  Created by Тигран on 25/10/2018.
//
//

import Foundation
import CoreData

@objc(Forecast)
public class Forecast: NSManagedObject {
	convenience init() {
		// Описание сущности
		let entity = CoreDataManager.shared.entityForName(entityName: "Forecast")
		
		// Создание нового объекта
		self.init(entity: entity, insertInto: CoreDataManager.shared.context)
	}
}
