//
//  StatisticsModel.swift
//  Delivery Calculator
//
//  Created by Тигран on 20/09/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import Foundation

class StatisticsModel {

	let azs: StationTypes
	let month: Int
	let day: String
	let hour: Int
	let fuel: Fuels.RawValue
	let count: Int
	let average: Double

	init(_ json: [String: Any]) {
		azs = json["AZS"] as? String == "Город" ? .city : .highway
		month = json["Month"] as! Int
		day = json["Day"] as! String
		hour = json["Hour"] as! Int
		fuel = json["Fuel"] as! Int
		count = json["Count"] as! Int
		average = json["Average"] as! Double
	}
}
