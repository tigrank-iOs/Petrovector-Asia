//
//  DecidableModel.swift
//  Delivery Calculator
//
//  Created by Тигран on 14.02.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import Foundation

class Object: Decodable {
    var Date: String = ""
    var PreviousDate: String = ""
    var PreviousURL: String = ""
    var Timestamp: String = ""
    var Valute: [Valute]
}

class Valute: Decodable {
    var ID: String = ""
    var NumCode: String = ""
    var CharCode: String = ""
    var Nominal: Double = 0
    var Name: String = ""
    var Value: Double = 0
    var Previous: Double = 0
}
