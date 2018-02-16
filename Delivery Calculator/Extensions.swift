//
//  Extensions.swift
//  Delivery Calculator
//
//  Created by Тигран on 16.02.2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

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
        guard textField == borderPrice else {
            self.borderCalculationButton(self)
            return true
        }
        self.baseCalculationButton(self)
        return true
    }
}

extension CalculatorVC: URLSessionDataDelegate {
    func downloadRate() {
        let url = URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")
        let defaultSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let dataTask = defaultSession.dataTask(with: url!)
        dataTask.resume()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        var response: Object?
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
        let rate = (round((usd.Value / (kgs.Value/Double(kgs.Nominal))) * 10000)) / 10000
        self.dataModel = Model(exchangeRate: rate)
    }
}
