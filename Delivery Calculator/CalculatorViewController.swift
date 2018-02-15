//
//  CalculatorViewController.swift
//  Delivery Calculator
//
//  Created by Тигран on 31.01.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, URLSessionDataDelegate {
    var dataModel: Model? = nil
    
    func downloadRate() {
        let url = URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")
        let defaultSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let dataTask = defaultSession.dataTask(with: url!)
        dataTask.resume()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        var response: Object?
        var rate: Double? = nil
        do {
            response = try JSONDecoder().decode(Object.self, from: data)
        } catch let error {
            print("JSONDecoder error: " + error.localizedDescription + "/n")
            return
        }
        guard let kgs = response?.Valute["KGS"],
        let usd = response?.Valute["USD"] else {
            print("Dictionary does not contain results key/n")
            return
        }
        rate = Double(Int((usd.Value / (kgs.Value/Double(kgs.Nominal))) * 10000)) / 10000
        self.dataModel = Model(exchangeRate: rate)
    }

    @IBOutlet weak var calculatorScrollView: UIScrollView!
    
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
        
        self.downloadRate()
        
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
