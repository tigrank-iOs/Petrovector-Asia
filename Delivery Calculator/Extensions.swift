//
//  Extensions.swift
//  Delivery Calculator
//
//  Created by Тигран on 16.02.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

extension BaseCalculatorVC: UIPickerViewDataSource, UIPickerViewDelegate {
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

extension BaseCalculatorVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.baseCalculationButton(self)
        return true
    }
}

extension BaseCalculatorVC: URLSessionDataDelegate {
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
        
//        let tabBar = self.tabBarController?.viewControllers
//        let settingVC = tabBar![1] as! SettingsVC
//        settingVC.dataModel = self.dataModel
//        
//        let borderVC = tabBar![2] as! BorderCalculatorVC
//        borderVC.dataModel = self.dataModel
    }
}
