//
//  CoreDataManager.swift
//  Delivery Calculator
//
//  Created by Тигран on 23/10/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import CoreData

public struct CoreDataManager {
	
	init() {
		
		let modelUrl = Bundle.main.url(forResource: "DataModel", withExtension: "momd")
		managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl!)!
		
		let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
		let storeUrl = docsUrl?.appendingPathComponent("base.sqlite")
		persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
		
		do {
			try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl!, options: nil)
		} catch {
			print(error.localizedDescription)
			abort()
		}
		
		
		managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
	}
	
	private var persistentStoreCoordinator: NSPersistentStoreCoordinator
	private var managedObjectContext: NSManagedObjectContext
	private var managedObjectModel: NSManagedObjectModel
	
	public func save(_ model: PriceCalculationModel) {
		let dataModel = NSEntityDescription.insertNewObject(forEntityName: "CalculationModel", into: managedObjectContext)
		dataModel.setValuesForKeys(["id" : model.id,
									"exchangeRate" : model.exchangeRate,
									"petrolDuty" : model.petrolDuty,
									"dieselDuty" : model.dieselDuty,
									"ecologicalRate" : model.ecologicalRate,
									"vat" : model.vat,
									"railwayRate" : model.railwayRate,
									"autoRate" : model.autoRate,
									"elnurRate" : model.elnurRate,
									"density80" : model.density80,
									"density92" : model.density92,
									"density95" : model.density95,
									"densityDT" : model.densityDT])
		do {
			try managedObjectContext.save()
		} catch {
			print(error.localizedDescription)
		}
	}
	
	public func get() {
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CalculationModel")
		request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
		do {
			let model = try managedObjectContext.execute(request)
		} catch {
			print(error.localizedDescription)
		}
	}
	
}
