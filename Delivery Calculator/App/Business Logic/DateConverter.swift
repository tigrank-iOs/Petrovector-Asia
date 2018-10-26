//
//  DateConverter.swift
//  Delivery Calculator
//
//  Created by Тигран on 28/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

struct DateConverter {

	let formatter = DateFormatter()

	func getHoursMinutes(_ date: Date) -> String {
		formatter.dateStyle = .none
		formatter.timeStyle = .short
		formatter.locale = Locale(identifier: "ru_RU")
		return formatter.string(from: date)
	}

	func getMonth(_ date: Date) -> Int {
		formatter.locale = Locale(identifier: "ru_RU")
		formatter.dateStyle = .short
		formatter.dateFormat = "dd.M.yyyy"
		formatter.timeStyle = .none
		return Int(formatter.string(from: date).split(separator: ".")[1]) ?? 0
	}

	func getDayOfWeek(_ date: Date) -> String {
		formatter.locale = Locale(identifier: "ru_RU")
		formatter.dateStyle = .full
		formatter.dateFormat = "cccc"
		formatter.timeStyle = .none
		return String(formatter.string(from: date).split(separator: ",").first!)
	}
}
