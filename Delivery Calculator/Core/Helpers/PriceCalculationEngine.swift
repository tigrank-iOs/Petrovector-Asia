//
//  PriceCalculationEngine.swift
//  Delivery Calculator
//
//  Created by Тигран on 21/09/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import Foundation

struct PriceCalculationEngine {
	
	func calculateBasePrice(withBorderPrice price: String?,
							petrol: String,
							forModel model: PriceCalculationModel) -> String {
		guard let priceUSD = price?.doubleValue else {
			return "Вы ввели недопустимую стоимость топлива"
		}
		let priceKGS = priceUSD * model.exchangeRate
		var duty: Double = 0
		if petrol == "ДТ" {
			duty = model.dieselDuty
		} else {
			duty = model.petrolDuty
		}
		let eco = model.ecologicalRate
		let priceAfterVat = (priceKGS + duty + eco) * (1.0 + (model.vat / 100))
		let railRate = model.railwayRate * model.exchangeRate
		let autoRate = model.autoRate / 59.0
		let elnurRate = model.elnurRate / 59.0
		var density: Double = 0
		switch petrol {
		case "АИ-80":
			density = model.density80
		case "АИ-92":
			density = model.density92
		case "АИ-95":
			density = model.density95
		default:
			density = model.densityDT
		}
		let liter = 1000 / density
		let totalPrice = (round(((priceAfterVat + railRate + autoRate + elnurRate) / liter) * 100)) / 100
		return "\(totalPrice) сом"
	}
	
	func calculateBorderPrice(withBasePrice price: String?, petrol: String, forModel model: PriceCalculationModel) -> String {
		guard let priceKGS = price?.doubleValue else {
			return "Вы ввели недопустимую стоимость топлива"
		}
		var density: Double = 0
		switch petrol {
		case "АИ-80":
			density = model.density80
		case "АИ-92":
			density = model.density92
		case "АИ-95":
			density = model.density95
		default:
			density = model.densityDT
		}
		let liter = 1000 / density
		let priceT = priceKGS * liter
		let railRate = model.railwayRate * model.exchangeRate
		let autoRate = model.autoRate / 59.0
		let elnurRate = model.elnurRate / 59.0
		let priceBeforeVat = (priceT - railRate - autoRate - elnurRate) / (1.0 + (model.vat / 100))
		var duty: Double = 0
		if petrol == "ДТ" {
			duty = model.dieselDuty
		} else {
			duty = model.petrolDuty
		}
		let eco = model.ecologicalRate
		let totalPrice = (round(((priceBeforeVat - eco - duty) / model.exchangeRate) * 100)) / 100
		return "$ \(totalPrice)"
	}
	
}
