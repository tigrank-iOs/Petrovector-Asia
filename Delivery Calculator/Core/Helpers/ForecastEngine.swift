//
//  ForecastEngine.swift
//  Delivery Calculator
//
//  Created by Тигран on 20/09/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import Foundation

struct ForecastEngine {

	func makeForecast(for model: CountModel) -> ([String: Double], Double) {
		var result: [String: Double] = [:]

		let forecastModels = DataManager.shared.modelsArray

		let month = model.month
		let day = model.dayOfWeek
		let hour = Int(DateConverter().getHoursMinutes(Date(timeIntervalSince1970: model.timeStart)).split(separator: ":").first!)!

		let multiplicator = 60 * 60 / (model.timeStop - model.timeStart)
		let enteredInHour = multiplicator * Double(model.enterCars)
		let passedInHour = multiplicator * Double(model.passedCars)

		let requiredModel = getRequiredModel(forMonth: month, day: day, type: model.azsType, from: forecastModels)

		var countPerDay = requiredModel.reduce(0) { (result, item) -> Int in
			return result + item.count
		}
		if model.azsType == .city {
			countPerDay /= 2
		}

		let hoursProportions: [Int: Double] = getHoursProportions(forModel: requiredModel, with: countPerDay)
		let fuelProportions: [String: Double] = getFuelProportions(forModel: requiredModel, with: countPerDay)

		let averageCheques = getAverageCheque(forModel: requiredModel)

		let enteredInDay = enteredInHour / hoursProportions[hour]!

		for fuel in fuelProportions {
			let count = fuel.value * enteredInDay
			let cheque = count * averageCheques[fuel.key]!
			result[fuel.key] = cheque
		}

		return (result, enteredInHour / passedInHour)
	}

	fileprivate func getRequiredModel(forMonth month: Int, day: String, type: AzsTypes, from modelsArray: [ForecastModel]) -> [ForecastModel] {
		return modelsArray.filter { (model) -> Bool in
			if model.month == month && model.day.lowercased() == day.lowercased() && model.azs == type {
				return true
			}
			return false
		}
	}

	fileprivate func getHoursProportions(forModel requiredModel: [ForecastModel], with count: Int) -> [Int: Double] {
		var proportions: [Int: Double] = [:]
		for model in requiredModel where proportions[model.hour] == nil {
			let hourly = requiredModel.filter { (item) -> Bool in
				if item.hour == model.hour {
					return true
				} else {
					return false
				}
				}.reduce(0) { (result, model) -> Int in
					return result + model.count
			}
			let proportion = Double(hourly) / Double(count)
			proportions[model.hour] = proportion
		}
		return proportions
	}

	fileprivate func getFuelProportions(forModel requiredModel: [ForecastModel], with count: Int) -> [String: Double] {
		var proportions: [String: Double] = [:]
		for model in requiredModel where proportions[model.fuel] == nil {
			let fuely = requiredModel.filter { (item) -> Bool in
				if item.fuel == model.fuel {
					return true
				} else {
					return false
				}
				}.reduce(0) { (result, model) -> Int in
					return result + model.count
			}
			let proportion = Double(fuely) / Double(count)
			proportions[model.fuel] = proportion
		}
		return proportions
	}

	fileprivate func getAverageCheque(forModel requiredModel: [ForecastModel]) -> [String: Double] {
		var averageCheques: [String: Double] = [:]
		for model in requiredModel where averageCheques[model.fuel] == nil {
			var count: Double = 0
			let fuely = requiredModel.filter { (item) -> Bool in
				if item.fuel == model.fuel {
					return true
				} else {
					return false
				}
				}.reduce(0) { (result, model) -> Double in
					count += 1
					return result + model.average
			}
			let cheque = fuely / count
			averageCheques[model.fuel] = cheque
		}
		return averageCheques
	}

}
