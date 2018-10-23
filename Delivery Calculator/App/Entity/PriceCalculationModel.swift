//
//  PriceCalculationModel.swift
//  Delivery Calculator
//
//  Created by Тигран on 14.02.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import Foundation

public struct PriceCalculationModel {

    var exchangeRate: Double?
    var petrolDuty: Double?
    var dieselDuty: Double?
    var ecologicalRate: Double?
    var vat: Double?
    var railwayRate: Double?
    var autoRate: Double?
    var elnurRate: Double?
    var density80: Double?
    var density92: Double?
    var density95: Double?
    var densityDT: Double?

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
}
