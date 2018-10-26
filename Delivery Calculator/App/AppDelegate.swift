//
//  AppDelegate.swift
//  Delivery Calculator
//
//  Created by Тигран on 31.01.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window?.backgroundColor = .white
		
        return true
    }
	
	func applicationWillTerminate(_ application: UIApplication) {
		CoreDataManager.shared.saveContext()
	}
}
