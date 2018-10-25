//
//  DataManager.swift
//  Delivery Calculator
//
//  Created by Тигран on 20/09/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import Foundation

class DataManager {

	static var shared = DataManager()
	private init() {
		self.loadData()
	}

	var modelsArray: [StatisticsModel] = []

	func loadData() {
		let optUrl = Bundle.main.url(forResource: "data", withExtension: "json")
		guard let url = optUrl else {
			print("Wrong file url")
			return
		}
		do {
			let data = try Data(contentsOf: url)
			let otpJsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]]

			guard let jsonArray = otpJsonArray else {
				print("Json format doesn`t match [[String: Any]]")
				return
			}
			for json in jsonArray {
				let model = StatisticsModel(json)
				self.modelsArray.append(model)
			}

		} catch {
			print(error.localizedDescription)
		}
		DispatchQueue.main.async {
			NotificationCenter.default.post(name: NSNotification.Name("dataManagerFinishedLoadingData"), object: nil)
		}
	}
}
