//
//  CalculatorViewController.swift
//  Delivery Calculator
//
//  Created by Тигран on 31.01.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    var dataModel: Model? = nil
    var petrol: String = "АИ-80"
    
    @IBOutlet weak var borderPrice: UITextField!
    @IBOutlet weak var petrolPicker: UIPickerView!
    @IBOutlet weak var baseResults: UILabel!
    @IBOutlet weak var calculatorScrollView: UIScrollView!
    @IBAction func baseCalculationButton(_ sender: Any) {
        let borderPriceUSD = Double(borderPrice.text!)
        let borderPriceKGS = borderPriceUSD! * (dataModel?.exchangeRate)!
        var duty: Double = 0
        if petrol == "ДТ" {
            duty = (dataModel?.dieselDuty)!
        } else {
            duty = (dataModel?.petrolDuty)!
        }
        let eco = (dataModel?.ecologicalRate)!
        let priceAfterVat = (borderPriceKGS + duty + eco) * (1.0 + ((dataModel?.vat)! / 100))
        let railRate = (dataModel?.railwayRate)! * (dataModel?.exchangeRate)!
        let autoRate = (dataModel?.autoRate)! / 59.0
        let elnurRate = (dataModel?.elnurRate)! / 59.0
        var density: Double = 0
        switch petrol {
        case "АИ-80":
            density = 0.715
        case "АИ-92":
            density = 0.735
        case "АИ-95":
            density = 0.733
        default:
            density = 0.855
        }
        let liter = 1000 / density
        let totalPrice = (priceAfterVat + railRate + autoRate + elnurRate) / liter
        self.baseResults.text = String(totalPrice)
    }
    
    var pickerData = [String]()
    
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        
        self.calculatorScrollView?.contentInset = contentInsets
        calculatorScrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        calculatorScrollView?.contentInset = contentInsets
        calculatorScrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func hideKeyboard() {
        self.calculatorScrollView?.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.petrolPicker.delegate = self
        self.petrolPicker.dataSource = self
        
        self.downloadRate()
        
        pickerData = ["АИ-80", "АИ-92", "АИ-95", "ДТ"]
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        calculatorScrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let tabBar = self.tabBarController?.viewControllers
        let settingVC = tabBar![1] as! SettingsViewController
        settingVC.dataModel = self.dataModel
        
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
