//
//  FormatterExt.swift
//  Delivery Calculator
//
//  Created by Тигран on 26/10/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import Foundation

extension Formatter {
	static let withSeparator: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.groupingSeparator = ","
		formatter.numberStyle = .decimal
		return formatter
	}()
}
