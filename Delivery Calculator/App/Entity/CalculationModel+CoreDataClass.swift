//
//  CalculationModel+CoreDataClass.swift
//  
//
//  Created by Тигран on 24/10/2018.
//
//

import Foundation
import CoreData

@objc(CalculationModel)
public class CalculationModel: NSManagedObject {
	convenience init() {
		// Описание сущности
		let entity = CoreDataManager.shared.entityForName(entityName: "CalculationModel")
		
		// Создание нового объекта
		self.init(entity: entity, insertInto: CoreDataManager.shared.context)
		
		self.exchangeRate = 0
		self.petrolDuty = 5000
		self.dieselDuty = 400
		self.ecologicalRate = 95
		self.vat = 12
		self.railwayRate = 13.5
		self.autoRate = 0
		self.elnurRate = 5550
		self.density80 = 0.715
		self.density92 = 0.735
		self.density95 = 0.733
		self.densityDT = 0.855
	}
}
