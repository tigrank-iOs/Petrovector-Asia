//
//  QueryService.swift
//  Delivery Calculator
//
//  Created by Тигран on 14.02.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import Foundation

class QueryService {
    typealias ExchangeRateResult = (ValuteAnswer?, String) -> ()
    
    var valuteKGS: ValuteAnswer? = nil
    var errorMessage = ""
    var delegate: URLSessionDataDelegate?
    
//    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func getExchangeRates(withDefaultSession defaultSession: URLSession) {
        dataTask?.cancel()
        
        let url = URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")
        
        dataTask = defaultSession.dataTask(with: url!) 
        dataTask?.resume()
    }
    
//    fileprivate func downloadRate(_ data: Data) {
//        var response: Object?
//        valuteKGS = nil
//
//        do {
//            response = try JSONDecoder().decode(Object.self, from: data)
//        } catch let error {
//            errorMessage += "JSONDecoder error: " + error.localizedDescription + "/n"
//            return
//        }
//        guard let array = response?.Valute["KGS"] else {
//            errorMessage += "Dictionary does not contain results key/n"
//            return
//        }
//        valuteKGS = array
//    }
}
