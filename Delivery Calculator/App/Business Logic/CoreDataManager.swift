//
//  CoreDataManager.swift
//  Delivery Calculator
//
//  Created by Тигран on 23/10/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import CoreData

public class CoreDataManager {
	
	static let shared: CoreDataManager = CoreDataManager()
	private init() { }
	
	public lazy var context: NSManagedObjectContext = {
		return persistentContainer.viewContext
	}()
	
	private lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "DataModel")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	public func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	public func delete(_ object: NSManagedObject) {
		let context = persistentContainer.viewContext
		context.delete(object)
		
	}
	
	public func entityForName(entityName: String) -> NSEntityDescription {
		return NSEntityDescription.entity(forEntityName: entityName, in: context)!
	}
}
