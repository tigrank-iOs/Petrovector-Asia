//
//  ForecastReportVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 28/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

class ForecastReportVC: UIViewController {

	var countModel: CountModel! {
		didSet {

		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		DataManager.shared.loadData()
		NotificationCenter.default.addObserver(self,
											   selector: #selector(calculate),
											   name: NSNotification.Name("dataManagerFinishedLoadingData"),
											   object: nil)
    }

	@objc func calculate() {
		ForecastEngine().makeForecast(for: countModel)
	}

}
