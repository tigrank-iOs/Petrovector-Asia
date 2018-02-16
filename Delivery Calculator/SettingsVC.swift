//
//  SettingsViewController.swift
//  Delivery Calculator
//
//  Created by Тигран on 31.01.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    var dataModel: Model? = nil {
        didSet {
            exchangeRate.text = "\(self.dataModel!.exchangeRate!) KGS"
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
        }
    }

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
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        
        self.settingsScrollView?.contentInset = contentInsets
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        settingsScrollView?.addGestureRecognizer(hideKeyboardGesture)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
