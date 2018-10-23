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
	public typealias ModelLoadResult = (PriceCalculationModel?, String) -> Void

	// MARK: Functions
	public func loadExchangeRate(completion: @escaping ModelLoadResult) {
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
				let model = PriceCalculationModel(exchangeRate: doubleRate)
				CoreDataManager().save(model)
				completion(model, strongSelf.errorMessage)
			} else {
				strongSelf.errorMessage += "Can`t load exchange rate\n"
				if strongSelf.checkSavedValues() {
					completion(PriceCalculationModel(storage: strongSelf.userDefaults), strongSelf.errorMessage)
				} else {
					strongSelf.errorMessage += "Can`t receive exchange rate"
					completion(nil, strongSelf.errorMessage)
				}
			}
		}
			dataTask.resume()
	}

	private func checkSavedValues() -> Bool {
		if userDefaults.value(forKey: "rate") == nil {
			return false
		} else {
			return true
		}
	}
}
