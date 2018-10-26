//
//  DoubleExt.swift
//  Delivery Calculator
//
//  Created by Тигран on 26/10/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import Foundation

extension Double {
	var formattedWithSeparator: String {
		return Formatter.withSeparator.string(for: self) ?? ""
	}
}
