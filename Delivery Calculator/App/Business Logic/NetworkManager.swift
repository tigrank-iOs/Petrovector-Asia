//
//  NetworkManager.swift
//  Delivery Calculator
//
//  Created by Тигран on 21/09/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import SwiftyXMLParser

public class NetworkManager {
	// MARK: - Singleton
	private init() { }
	public static let shared: NetworkManager = NetworkManager()

	// MARK: - Variables
	private let userDefaults = UserDefaults.standard
	private var errorMessage: String = ""
	public typealias RateLoadResult = (Double?, String) -> Void

	// MARK: Functions
	public func loadExchangeRate(completion: @escaping RateLoadResult) {
		errorMessage = ""
		let optUrl = URL(string: Constants.API.exchangeRateURL)
		let session = URLSession(configuration: .default)
		guard let url = optUrl else {
			errorMessage += "Download rate error: wrong url\n"
			completion(nil, errorMessage)
			return
		}
		let dataTask = session.dataTask(with: url) { [weak self] (data, _, error) in
			guard let strongSelf = self else { return }
			guard let data = data, error == nil else {
				strongSelf.errorMessage += "Data task error: \(error!.localizedDescription)\n"
				completion(nil, strongSelf.errorMessage)
				return
			}
			let xml = XML.parse(data)
			let rate = xml["CurrencyRates", "Currency", 0, "Value"].text
			let optDoubleRate = rate?.doubleValue
			
			if let doubleRate = optDoubleRate {
				completion(doubleRate, strongSelf.errorMessage)
			} else {
				strongSelf.errorMessage += "Can`t receive exchange rate"
				completion(nil, strongSelf.errorMessage)
			}
		}
		dataTask.resume()
	}
}
