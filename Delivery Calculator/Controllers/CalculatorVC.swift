//
//  CalculatorVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 31.01.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

class CalculatorVC: UIViewController {
    var dataModel: Model?
    var petrol: String = "АИ-80"

	@IBOutlet weak var whereSelector: UISegmentedControl!
	@IBOutlet weak var incomePriceTag: UILabel!
	@IBOutlet weak var incomePrice: UITextField!
	@IBOutlet weak var outcomePrice: UILabel!
	@IBOutlet weak var outcomePriceTag: UILabel!
    @IBOutlet weak var petrolPicker: UIPickerView!
    @IBOutlet weak var calculatorScrollView: UIScrollView!
	@IBOutlet weak var calculationButton: UIButton!
    @IBAction func calculationPressed(_ sender: Any) {
		if whereSelector.selectedSegmentIndex == 0 {
			self.outcomePrice.text = dataModel?.calculateBorderPrice(withBasePrice: incomePrice.text, petrol: petrol)
			self.calculatorScrollView?.endEditing(true)
		} else if whereSelector.selectedSegmentIndex == 1 {
			self.outcomePrice.text = dataModel?.calculateBasePrice(withBorderPrice: incomePrice.text, petrol: petrol)
			self.calculatorScrollView?.endEditing(true)
		}
    }
    
    var pickerData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        petrolPicker.delegate = self
        petrolPicker.dataSource = self
        
        downloadRate()
        
        pickerData = ["АИ-80", "АИ-92", "АИ-95", "ДТ"]
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        calculatorScrollView?.addGestureRecognizer(hideKeyboardGesture)
		
		calculatorScrollView.isScrollEnabled = false
		
		incomePrice.keyboardType = .decimalPad
		
		whereSelector.addTarget(self, action: #selector(self.whereChanged), for: .allEvents)
		
		incomePrice.setBottomBorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		incomePrice.becomeFirstResponder()
		incomePrice.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
	
	@objc func keyboardWasShown(notification: Notification) {
		let info = notification.userInfo! as NSDictionary
		let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
		let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
		
		calculatorScrollView?.contentInset = contentInsets
		calculatorScrollView?.scrollIndicatorInsets = contentInsets
		
		if Int(UIScreen.main.bounds.size.height) <= 568 {
			calculatorScrollView.isScrollEnabled = true
		}
	}
	
	@objc func keyboardWillBeHidden(notification: Notification) {
		let contentInsets = UIEdgeInsets.zero
		calculatorScrollView?.contentInset = contentInsets
		calculatorScrollView?.scrollIndicatorInsets = contentInsets
		
		calculatorScrollView.bounds = CGRect(x: 0.0, y: 0.0, width: calculatorScrollView.bounds.width, height: calculatorScrollView.bounds.height)
		calculatorScrollView.isScrollEnabled = false
	}
	
	@objc func hideKeyboard() {
		self.calculatorScrollView?.endEditing(true)
		
		calculatorScrollView.bounds = CGRect(x: 0.0, y: 0.0, width: calculatorScrollView.bounds.width, height: calculatorScrollView.bounds.height)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSettingsVC" {
            let settingVC = segue.destination as! SettingsTableVC
            settingVC.dataModel = self.dataModel
        }
    }
}
