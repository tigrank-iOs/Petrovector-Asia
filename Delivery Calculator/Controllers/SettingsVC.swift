//
//  SettingsVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 31.01.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    var dataModel: Model? = nil

    @IBOutlet weak var settingsScrollView: UIScrollView!
	
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
    
    @IBAction func saveButton(_ sender: Any) {
		let userDefaults = UserDefaults.standard
		userDefaults.set(dataModel?.exchangeRate, forKey: "rate")
		userDefaults.set(petrolDuty.text?.doubleValue, forKey: "petrolDuty")
		userDefaults.set(dieselDuty.text?.doubleValue, forKey: "dieselDuty")
		userDefaults.set(ecologicalRate.text?.doubleValue, forKey: "ecologicalRate")
		userDefaults.set(vat.text?.doubleValue, forKey: "vat")
		userDefaults.set(railwayRate.text?.doubleValue, forKey: "railwayRate")
		userDefaults.set(autoRate.text?.doubleValue, forKey: "autoRate")
		userDefaults.set(elnurRate.text?.doubleValue, forKey: "elnurRate")
		userDefaults.set(density80.text?.doubleValue, forKey: "density80")
		userDefaults.set(density92.text?.doubleValue, forKey: "density92")
		userDefaults.set(density95.text?.doubleValue, forKey: "density95")
		userDefaults.set(densityDT.text?.doubleValue, forKey: "densityDT")
		
		self.dataModel = Model(storage: userDefaults)
		let navigationVC = self.parent as! UINavigationController
		let calculatorVC = navigationVC.viewControllers[0] as! CalculatorVC
		calculatorVC.dataModel = dataModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        settingsScrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        exchangeRate.text = "\(dataModel!.exchangeRate!) KGS"
        petrolDuty.text = "\(dataModel!.petrolDuty!)"
        dieselDuty.text = "\(dataModel!.dieselDuty!)"
        ecologicalRate.text = "\(dataModel!.ecologicalRate!)"
        vat.text = "\(dataModel!.vat!)"
        railwayRate.text = "\(dataModel!.railwayRate!)"
        autoRate.text = "\(dataModel!.autoRate!)"
        elnurRate.text = "\(dataModel!.elnurRate!)"
        density80.text = "\(dataModel!.density80!)"
        density92.text = "\(dataModel!.density92!)"
        density95.text = "\(dataModel!.density95!)"
        densityDT.text = "\(dataModel!.densityDT!)"
        
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
		
		settingsScrollView?.contentInset = contentInsets
		settingsScrollView?.scrollIndicatorInsets = contentInsets
	}
	
	@objc func keyboardWillBeHidden(notification: Notification) {
		let contentInsets = UIEdgeInsets.zero
		settingsScrollView?.contentInset = contentInsets
		settingsScrollView?.scrollIndicatorInsets = contentInsets
	}
	
	@objc func hideKeyboard() {
		self.settingsScrollView?.endEditing(true)
	}
	
	
}
