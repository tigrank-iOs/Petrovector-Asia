//
//  Extensions.swift
//  Delivery Calculator
//
//  Created by Тигран on 16.02.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit
import SwiftyXMLParser

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
            petrol = "АИ-80"
        case 1:
            petrol = "АИ-92"
        case 2:
            petrol = "АИ-95"
        default:
            petrol = "ДТ"
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
			calculationButton.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 0.3)
			calculationButton.isEnabled = false
		} else {
			calculationButton.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
			calculationButton.isEnabled = true
		}
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if (textField.text?.isEmpty)! {
			calculationButton.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 0.3)
			calculationButton.isEnabled = false
			return true
		} else {
			calculationButton.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
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

extension CalculatorVC: URLSessionDataDelegate {
    func downloadRate() {
        let url = URL(string: "http://nbkr.kg/XML/daily.xml")
        let defaultSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let dataTask = defaultSession.dataTask(with: url!)
        dataTask.resume()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let xml = XML.parse(data)
        let rate = xml["CurrencyRates", "Currency", 0, "Value"].text
        let doubleRate = rate?.doubleValue
		if checkSavedValues() {
			let userDefaults = UserDefaults.standard
			self.dataModel = Model(storage: userDefaults)
		} else {
			self.dataModel = Model(exchangeRate: doubleRate!)
		}
    }
    
    func checkSavedValues() -> Bool {
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "rate") == nil {
            return false
        } else {
            return true
        }
    }
}

extension SettingsTableVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFields = [petrolDuty, dieselDuty, ecologicalRate, vat, railwayRate, autoRate, elnurRate, density80, density92, density95, densityDT]
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

extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}

extension UITextField {
	func setBottomBorder() {
		self.borderStyle = .none
		self.layer.backgroundColor = UIColor.white.cgColor
		
		self.layer.masksToBounds = false
		self.layer.shadowColor = UIColor.lightGray.cgColor
		self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
		self.layer.shadowOpacity = 1.0
		self.layer.shadowRadius = 0.0
	}
}
