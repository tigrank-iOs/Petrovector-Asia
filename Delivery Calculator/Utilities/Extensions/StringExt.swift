//
//  StringExt.swift
//  Delivery Calculator
//
//  Created by Тигран on 24/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import Foundation

extension String {
	static let numberFormatter = NumberFormatter()
	var doubleValue: Double {
		String.numberFormatter.decimalSeparator = "."
		if let result =  String.numberFormatter.number(from: self) {
			return result.doubleValue
		} else {
			String.numberFormatter.decimalSeparator = ","
			if let result = String.numberFormatter.number(from: self) {
				return result.doubleValue
			}
		}
		return 0
	}
}
