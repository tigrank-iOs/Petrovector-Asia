//
//  ForecastVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 27/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

class ForecastVC: PageVC {

	// MARK: - Variables
	var countModelArray: [CountModel] = []

	// MARK: - Outlets
	@IBOutlet weak var tableView: UITableView!

	// MARK: - VCLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
    }

	// MARK: - Segue
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showModel" {
			let reportVC = segue.destination as! ForecastReportVC
			let indexPath = tableView.indexPathForSelectedRow
			reportVC.countModel = countModelArray[(indexPath?.row)!]
		}
	}

	@IBAction func unwindToForecastVC(segue: UIStoryboardSegue) { }
}

extension ForecastVC: UITableViewDelegate, UITableViewDataSource {

	// MARK: - UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return countModelArray.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath)
		cell.textLabel?.text = countModelArray[indexPath.row].name
		return cell
	}

	// MARK: - UITableViewDelegate
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
	}
}

extension ForecastVC: CountSaveProtocol {

	// MARK: - CountSaveProtocol
	func didSaveModel(_ model: CountModel) {
		countModelArray.append(model)
		tableView.reloadData()
	}
}
