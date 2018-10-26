//
//  ForecastVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 27/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit
import CoreData

class ForecastVC: PageVC {

	// MARK: - Variables
	var countModelArray: [CountModel] = [] {
		didSet {
			cityArray = countModelArray.filter { $0.azsType == "Город" }
			highwayArray = countModelArray.filter { $0.azsType == "Трасса" }
		}
	}
	var cityArray: [CountModel]?
	var highwayArray: [CountModel]?

	// MARK: - Outlets
	@IBOutlet weak var tableView: UITableView!

	// MARK: - VCLifeCycle
	override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		
		fetchData()
    }
	
	// MARK: - Private Functions
	private func fetchData() {
		countModelArray.removeAll()
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CountModel")
		request.sortDescriptors = [NSSortDescriptor(key: "timeStart", ascending: false)]
		request.returnsObjectsAsFaults = false
		
		do {
			let results = try CoreDataManager.shared.context.fetch(request) as! [CountModel]
			countModelArray.append(contentsOf: results)
			self.tableView.reloadData()
		} catch {
			print(error.localizedDescription)
		}
	}

	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showModel" {
			let reportVC = segue.destination as! ForecastReportVC
			guard let indexPath = tableView.indexPathForSelectedRow else { return }
			if indexPath.section == 0 {
				if cityArray?.count != 0 {
					reportVC.countModel = cityArray?[indexPath.row]
				} else {
					reportVC.countModel = highwayArray?[indexPath.row]
				}
			} else {
				reportVC.countModel = highwayArray?[indexPath.row]
			}
		}
	}

	@IBAction func unwindToForecastVC(segue: UIStoryboardSegue) { }
}

extension ForecastVC: UITableViewDelegate, UITableViewDataSource {

	// MARK: - UITableViewDataSource
	func numberOfSections(in tableView: UITableView) -> Int {
		if cityArray?.count != 0 && highwayArray?.count != 0 {
			return 2
		}
		return 1
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			if cityArray?.count != 0 {
				return "Город"
			}
		}
		if highwayArray?.count != 0 {
			return "Трасса"
		}
		return nil
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			if cityArray?.count != 0 {
				return cityArray!.count
			}
		}
		return highwayArray!.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath)
		
		if indexPath.section == 0 {
			if cityArray?.count != 0 {
				cell.textLabel?.text = cityArray?[indexPath.row].name
			} else {
				cell.textLabel?.text = highwayArray?[indexPath.row].name
			}
		} else {
			cell.textLabel?.text = highwayArray?[indexPath.row].name
		}
		
		return cell
	}

	// MARK: - UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			var object: CountModel?
			
			if cityArray?.count != 0 && highwayArray?.count != 0 {
				if indexPath.section == 0 {
					object = cityArray?[indexPath.row]
				} else {
					object = highwayArray?[indexPath.row]
				}
			} else if cityArray?.count != 0 {
				object = cityArray?[indexPath.row]
			} else if highwayArray?.count != 0 {
				object = highwayArray?[indexPath.row]
			} else {
				object = nil
			}
			
			if let managedObject = object {
				CoreDataManager.shared.delete(managedObject)
				CoreDataManager.shared.saveContext()
				self.fetchData()
			}
		}
	}
}

extension ForecastVC: CountSaveProtocol {

	// MARK: - CountSaveProtocol
	func didSaveModel(_ model: CountModel) {
		fetchData()
	}
}
