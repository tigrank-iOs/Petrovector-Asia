//
//  CalculatorVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 31.01.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

class CalculatorVC: UIViewController {
    var dataModel: Model? = nil
    var petrol: String = "АИ-80"
    
    @IBOutlet weak var borderPrice: UITextField!
    @IBOutlet weak var petrolPicker: UIPickerView!
    @IBOutlet weak var baseResults: UILabel!
    @IBOutlet weak var calculatorScrollView: UIScrollView!
    @IBAction func baseCalculationButton(_ sender: Any) {
        self.baseResults.text = dataModel?.calculateBasePrice(withBorderPrice: borderPrice.text, petrol: petrol)
        self.calculatorScrollView?.endEditing(true)
    }
    
    @IBOutlet weak var basePrice: UITextField!
    @IBOutlet weak var borderResults: UILabel!
    @IBAction func borderCalculationButton(_ sender: Any) {
        self.borderResults.text = dataModel?.calculateBorderPrice(withBasePrice: basePrice.text, petrol: petrol)
        self.calculatorScrollView?.endEditing(true)
    }
    
    var pickerData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.petrolPicker.delegate = self
        self.petrolPicker.dataSource = self
        
        self.downloadRate()
        
        pickerData = ["АИ-80", "АИ-92", "АИ-95", "ДТ"]
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        calculatorScrollView?.addGestureRecognizer(hideKeyboardGesture)
		
		calculatorScrollView.isScrollEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
		
		calculatorScrollView.isScrollEnabled = true
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
	}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSettingsVC" {
            let settingVC = segue.destination as! SettingsVC
            settingVC.dataModel = self.dataModel
        }
    }
}
