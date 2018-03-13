//
//  Model.swift
//  Delivery Calculator
//
//  Created by Тигран on 14.02.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import Foundation

class Model {
    
    var exchangeRate: Double? = nil
    var petrolDuty: Double? = nil
    var dieselDuty: Double? = nil
    var ecologicalRate: Double? = nil
    var vat: Double? = nil
    var railwayRate: Double? = nil
    var autoRate: Double? = nil
    var elnurRate: Double? = nil
    var density80: Double? = nil
    var density92: Double? = nil
    var density95: Double? = nil
    var densityDT: Double? = nil
    
	init(storage: UserDefaults) {
		self.exchangeRate = storage.double(forKey: "rate")
		self.petrolDuty = storage.double(forKey: "petrolDuty")
		self.dieselDuty = storage.double(forKey: "dieselDuty")
		self.ecologicalRate = storage.double(forKey: "ecologicalRate")
		self.vat = storage.double(forKey: "vat")
		self.railwayRate = storage.double(forKey: "railwayRate")
		self.autoRate = storage.double(forKey: "autoRate")
		self.elnurRate = storage.double(forKey: "elnurRate")
		self.density80 = storage.double(forKey: "density80")
		self.density92 = storage.double(forKey: "density92")
		self.density95 = storage.double(forKey: "density95")
		self.densityDT = storage.double(forKey: "densityDT")
	}
    
	init(exchangeRate: Double) {
        self.exchangeRate = exchangeRate
        self.petrolDuty = 5000
        self.dieselDuty = 400
        self.ecologicalRate = 95
        self.vat = 12
        self.railwayRate = 13.5
        self.autoRate = 0
        self.elnurRate = 5550
        self.density80 = 0.715
        self.density92 = 0.735
        self.density95 = 0.733
        self.densityDT = 0.855
    }
    
    func calculateBasePrice(withBorderPrice price: String?, petrol: String) -> String {
        guard let priceUSD = Double(price!) else {
            return "Вы ввели недопустимую стоимость топлива"
        }
        let priceKGS = priceUSD * (self.exchangeRate)!
        var duty: Double = 0
        if petrol == "ДТ" {
            duty = (self.dieselDuty)!
        } else {
            duty = (self.petrolDuty)!
        }
        let eco = (self.ecologicalRate)!
        let priceAfterVat = (priceKGS + duty + eco) * (1.0 + ((self.vat)! / 100))
        let railRate = (self.railwayRate)! * (self.exchangeRate)!
        let autoRate = (self.autoRate)! / 59.0
        let elnurRate = (self.elnurRate)! / 59.0
        var density: Double = 0
        switch petrol {
        case "АИ-80":
            density = self.density80!
        case "АИ-92":
            density = self.density92!
        case "АИ-95":
            density = self.density95!
        default:
            density = self.densityDT!
        }
        let liter = 1000 / density
        let totalPrice = (round(((priceAfterVat + railRate + autoRate + elnurRate) / liter) * 100)) / 100
        return "Итоговая цена за литр \(petrol) на нефтебаза составит \(totalPrice) сом."
    }
	
    func calculateBorderPrice(withBasePrice price: String?, petrol: String) -> String {
        guard let priceKGS = Double(price!) else {
            return "Вы ввели недопустимую стоимость топлива"
        }
        var density: Double = 0
        switch petrol {
        case "АИ-80":
            density = self.density80!
        case "АИ-92":
            density = self.density92!
        case "АИ-95":
            density = self.density95!
        default:
            density = self.densityDT!
        }
        let liter = 1000 / density
        let priceT = priceKGS * liter
        let railRate = (self.railwayRate)! * (self.exchangeRate)!
        let autoRate = (self.autoRate)! / 59.0
        let elnurRate = (self.elnurRate)! / 59.0
        let priceBeforeVat = (priceT - railRate - autoRate - elnurRate) / (1.0 + ((self.vat)! / 100))
        var duty: Double = 0
        if petrol == "ДТ" {
            duty = (self.dieselDuty)!
        } else {
            duty = (self.petrolDuty)!
        }
        let eco = (self.ecologicalRate)!
        let totalPrice = (round(((priceBeforeVat - eco - duty) / self.exchangeRate!) * 100)) / 100
        return "Итоговая цена за тонну \(petrol) на границе составит $ \(totalPrice)."
    }
}
