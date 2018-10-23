//
//  Constants.swift
//  Delivery Calculator
//
//  Created by Тигран on 21/09/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import Foundation

public class Constants {
	
	private init() { }
	
	enum FuelType: String {
		case ai80 = "АИ-80"
		case ai92 = "АИ-92"
		case ai95 = "АИ-95"
		case dt = "ДТ"
	}
	
	public struct API {
		static public let exchangeRateURL = "http://nbkr.kg/XML/daily.xml"
	}
}
