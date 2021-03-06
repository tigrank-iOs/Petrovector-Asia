//
//  SettingsTableVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 26.03.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit
import SwiftyXMLParser

class SettingsTableVC: UITableViewController {

	// MARK: - Variables
	var dataModel: CalculationModel!

	// MARK: - Outlets
	@IBOutlet weak var exchangeRate: UILabel!
	@IBOutlet weak var petrolDuty: UITextField!
	@IBOutlet weak var dieselDuty: UITextField!
	@IBOutlet weak var ecologicalRate: UITextField!
	@IBOutlet weak var vat: UITextField!
	@IBOutlet weak var railwayRate: UITextField!
	@IBOutlet weak var autoRate: UITextField!
	@IBOutlet weak var elnurRate: UITextField!
	@IBOutlet weak var density80: UITextField!
	@IBOutlet weak var density92: UITextField!
	@IBOutlet weak var density95: UITextField!
	@IBOutlet weak var densityDT: UITextField!

	// MARK: - VCLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
		
//		CoreDataManager.shared.get()

		let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
		tableView.addGestureRecognizer(hideKeyboardGesture)

		let textFields = [petrolDuty,
						  dieselDuty,
						  ecologicalRate,
						  vat,
						  railwayRate,
						  autoRate,
						  elnurRate,
						  density80,
						  density92,
						  density95,
						  densityDT]

		textFields.forEach { (field) in
			field?.delegate = self
			field?.keyboardType = .numbersAndPunctuation
			field?.borderStyle = .none
		}
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		exchangeRate.text = "\(dataModel.exchangeRate) KGS"
		petrolDuty.text = "\(dataModel.petrolDuty)"
		dieselDuty.text = "\(dataModel.dieselDuty)"
		ecologicalRate.text = "\(dataModel.ecologicalRate)"
		vat.text = "\(dataModel.vat)"
		railwayRate.text = "\(dataModel.railwayRate)"
		autoRate.text = "\(dataModel.autoRate)"
		elnurRate.text = "\(dataModel.elnurRate)"
		density80.text = "\(dataModel.density80)"
		density92.text = "\(dataModel.density92)"
		density95.text = "\(dataModel.density95)"
		densityDT.text = "\(dataModel.densityDT)"
	}

	// MARK: - OBJC Functions
	@objc func hideKeyboard() {
		self.tableView.endEditing(true)
	}
	
	// MARK: - Actions
	@IBAction func saveButton(_ sender: Any) {
		
		dataModel.setValue(petrolDuty.text?.doubleValue, forKey: "petrolDuty")
		dataModel.setValue(dieselDuty.text?.doubleValue, forKey: "dieselDuty")
		dataModel.setValue(ecologicalRate.text?.doubleValue, forKey: "ecologicalRate")
		dataModel.setValue(vat.text?.doubleValue, forKey: "vat")
		dataModel.setValue(railwayRate.text?.doubleValue, forKey: "railwayRate")
		dataModel.setValue(autoRate.text?.doubleValue, forKey: "autoRate")
		dataModel.setValue(elnurRate.text?.doubleValue, forKey: "elnurRate")
		dataModel.setValue(density80.text?.doubleValue, forKey: "density80")
		dataModel.setValue(density92.text?.doubleValue, forKey: "density92")
		dataModel.setValue(density95.text?.doubleValue, forKey: "density95")
		dataModel.setValue(densityDT.text?.doubleValue, forKey: "densityDT")
		
		CoreDataManager.shared.saveContext()
		
		let navigationVC = self.parent as! UINavigationController
		let calculatorVC = navigationVC.viewControllers[1] as! CalculatorVC
		calculatorVC.dataModel = dataModel
		
		let alert = UIAlertController(title: "", message: "Настройки успешно сохранены", preferredStyle: .alert)
		let action = UIAlertAction(title: "Ок", style: .default)
		alert.addAction(action)
		self.present(alert, animated: true)
		
		hideKeyboard()
	}
}

extension SettingsTableVC: UITextFieldDelegate {
	
	// MARK: - UITextFieldDelegate
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let textFields = [petrolDuty,
						  dieselDuty,
						  ecologicalRate,
						  vat, railwayRate,
						  autoRate,
						  elnurRate,
						  density80,
						  density92,
						  density95,
						  densityDT]

		if textField.returnKeyType == .done {
			saveButton(self)
			return true
		} else if textField.returnKeyType == .continue {
			let currentTextFieldNumber = textFields.index(where: { selectedTextField -> Bool in
				guard selectedTextField == textField else {
					return false
				}
				return true
			})
			textFields[currentTextFieldNumber! + 1]?.becomeFirstResponder()
			return true
		}
		return false
	}
}
