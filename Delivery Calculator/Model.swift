//
//  Model.swift
//  Delivery Calculator
//
//  Created by Тигран on 14.02.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import Foundation

class Model: NSObject {
    
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
    
    override init() {
        super.init()
    }
    
    convenience init(exchangeRate: Double?) {
        self.init()
        self.exchangeRate = exchangeRate
        self.petrolDuty = 5000
        self.dieselDuty = 400
        self.ecologicalRate = 95
        self.vat = 12
        self.railwayRate = 13.5
        self.autoRate = 1000
        self.elnurRate = 4500
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
}
