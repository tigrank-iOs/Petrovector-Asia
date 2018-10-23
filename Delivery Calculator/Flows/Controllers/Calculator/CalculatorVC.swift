//
//  CalculatorVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 31.01.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

class CalculatorVC: PageVC {

	// MARK: - Variables
    var dataModel: PriceCalculationModel?
    var petrol: String = "АИ-80"
	let pickerData: [String] = [Constants.FuelType.ai80.rawValue,
					  Constants.FuelType.ai92.rawValue,
					  Constants.FuelType.ai95.rawValue,
					  Constants.FuelType.dt.rawValue]

	// MARK: - Outlets
	@IBOutlet weak var whereSelector: UISegmentedControl!
	@IBOutlet weak var incomePriceTag: UILabel!
	@IBOutlet weak var incomePrice: UITextField!
	@IBOutlet weak var outcomePrice: UILabel!
	@IBOutlet weak var outcomePriceTag: UILabel!
    @IBOutlet weak var petrolPicker: UIPickerView!
    @IBOutlet weak var calculatorScrollView: UIScrollView!
	@IBOutlet weak var calculationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        petrolPicker.delegate = self
        petrolPicker.dataSource = self

		NetworkManager.shared.loadExchangeRate { [weak self] (model, error) in
			guard let strongSelf = self else { return }
			if let model = model {
				strongSelf.dataModel = model
			}
			if !(error.isEmpty) {
				print(error)
			}
		}

        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        calculatorScrollView?.addGestureRecognizer(hideKeyboardGesture)

		calculatorScrollView.isScrollEnabled = false

		incomePrice.keyboardType = .decimalPad

		whereSelector.addTarget(self, action: #selector(self.whereChanged), for: UIControl.Event.allEvents)

		incomePrice.setBottomBorder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
											   selector: #selector(self.keyboardWasShown(notification:)),
											   name: UIResponder.keyboardWillShowNotification,
											   object: nil)

        NotificationCenter.default.addObserver(self,
											   selector: #selector(self.keyboardWillBeHidden(notification:)),
											   name: UIResponder.keyboardWillHideNotification,
											   object: nil)

		incomePrice.becomeFirstResponder()
		incomePrice.text = ""
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

	@objc func keyboardWasShown(notification: Notification) {
		let info = notification.userInfo! as NSDictionary
		let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
		let contentInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)

		calculatorScrollView?.contentInset = contentInsets
		calculatorScrollView?.scrollIndicatorInsets = contentInsets

		if Int(UIScreen.main.bounds.size.height) <= 568 {
			calculatorScrollView.isScrollEnabled = true
		}
	}

	@objc func keyboardWillBeHidden(notification: Notification) {
		let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		calculatorScrollView?.contentInset = contentInsets
		calculatorScrollView?.scrollIndicatorInsets = contentInsets

		calculatorScrollView.bounds = CGRect(x: 0.0,
											 y: 0.0,
											 width: calculatorScrollView.bounds.width,
											 height: calculatorScrollView.bounds.height)

		calculatorScrollView.isScrollEnabled = false
	}

	@objc func hideKeyboard() {
		self.calculatorScrollView?.endEditing(true)

		calculatorScrollView.bounds = CGRect(x: 0.0,
											 y: 0.0,
											 width: calculatorScrollView.bounds.width,
											 height: calculatorScrollView.bounds.height)

		calculatorScrollView.isScrollEnabled = false
		self.calculationPressed(self)
	}


	@objc func whereChanged() {
		if whereSelector.selectedSegmentIndex == 0 {
			incomePriceTag.text = "Стоимость топлива за литр"
			incomePrice.placeholder = "0 сом."
			outcomePriceTag.text = "за тонну"
			incomePrice.becomeFirstResponder()
		} else if whereSelector.selectedSegmentIndex == 1 {
			incomePriceTag.text = "Стоимость топлива за тонну"
			incomePrice.placeholder = "$ 0"
			outcomePriceTag.text = "за литр"
			incomePrice.becomeFirstResponder()
		}
	}

	@IBAction func calculationPressed(_ sender: Any) {
		guard let model = dataModel else {
			print("No dataModel received")
			return
		}
		if whereSelector.selectedSegmentIndex == 0 {
			self.outcomePrice.text = PriceCalculationEngine().calculateBorderPrice(withBasePrice: incomePrice.text,
																				   petrol: petrol,
																				   forModel: model)
			self.calculatorScrollView?.endEditing(true)
		} else if whereSelector.selectedSegmentIndex == 1 {
			self.outcomePrice.text = PriceCalculationEngine().calculateBasePrice(withBorderPrice: incomePrice.text,
																				 petrol: petrol,
																				 forModel: model)
			self.calculatorScrollView?.endEditing(true)
		}
	}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSettingsVC" {
            let settingVC = segue.destination as! SettingsTableVC
            settingVC.dataModel = self.dataModel
        }
    }
}

extension CalculatorVC: UIPickerViewDataSource, UIPickerViewDelegate {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.pickerData.count
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.pickerData[row]
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		switch row {
		case 0:
			petrol = Constants.FuelType.ai80.rawValue
		case 1:
			petrol = Constants.FuelType.ai92.rawValue
		case 2:
			petrol = Constants.FuelType.ai95.rawValue
		default:
			petrol = Constants.FuelType.dt.rawValue
		}
	}
}

extension CalculatorVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.calculationPressed(self)
		return true
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.text = ""
		outcomePrice.isHidden = true
		outcomePriceTag.isHidden = true
		if (textField.text?.isEmpty)! {
			calculationButton.backgroundColor = UIColor(displayP3Red: 0.0/255.0,
														green: 122.0/255.0,
														blue: 255.0/255.0,
														alpha: 0.3)

			calculationButton.isEnabled = false
		} else {
			calculationButton.backgroundColor = UIColor(displayP3Red: 0.0/255.0,
														green: 122.0/255.0,
														blue: 255.0/255.0,
														alpha: 1.0)

			calculationButton.isEnabled = true
		}
	}

	func textField(_ textField: UITextField,
				   shouldChangeCharactersIn range: NSRange,
				   replacementString string: String) -> Bool {

		if (textField.text?.isEmpty)! {
			calculationButton.backgroundColor = UIColor(displayP3Red: 0.0/255.0,
														green: 122.0/255.0,
														blue: 255.0/255.0,
														alpha: 0.3)

			calculationButton.isEnabled = false
			return true
		} else {
			calculationButton.backgroundColor = UIColor(displayP3Red: 0.0/255.0,
														green: 122.0/255.0,
														blue: 255.0/255.0,
														alpha: 1.0)

			calculationButton.isEnabled = true
			return true
		}
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		if (textField.text?.isEmpty)! {
			outcomePrice.isHidden = true
			outcomePriceTag.isHidden = true
		} else {
			outcomePrice.isHidden = false
			outcomePriceTag.isHidden = false
		}
	}
}
