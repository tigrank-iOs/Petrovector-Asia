//
//  CountModel.swift
//  Delivery Calculator
//
//  Created by Тигран on 28/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import MapKit

enum AzsTypes {
	case city
	case highway
}

struct CountModel {

	let name: String
	var azsType: AzsTypes = .city
	let month: Int
	let dayOfWeek: String
	let timeStart: TimeInterval
	let timeStop: TimeInterval
	var geoposition: CLLocationCoordinate2D?
	let passedCars: Int
	let enterCars: Int

	init(name: String, month: Int, day: String, start: TimeInterval, stop: TimeInterval, passed: Int, enter: Int) {
		self.name = name
		self.month = month
		dayOfWeek = day
		timeStart = start
		timeStop = stop
		passedCars = passed
		enterCars = enter
	}
}
