//
//  ForecastReportVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 28/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit
import MapKit

class ForecastReportVC: UIViewController {

	// MARK: - Variables
	var countModel: CountModel!
	private let myPointAnnotation = MKPointAnnotation()
	
	// MARK: - Outlets
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var azsTypeLabel: UILabel!
	@IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var passedLabel: UILabel!
	@IBOutlet weak var enteredLabel: UILabel!
	@IBOutlet weak var ai80Label: UILabel!
	@IBOutlet weak var ai92Label: UILabel!
	@IBOutlet weak var ai95Label: UILabel!
	@IBOutlet weak var dtLabel: UILabel!
	@IBOutlet weak var conversionLabel: UILabel!
	
	@IBOutlet weak var mapView: MKMapView!
	
	// MARK: - VCLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.nameLabel.text = countModel.name
		self.azsTypeLabel.text = countModel.azsType
		self.dayLabel.text = countModel.dayOfWeek
		self.passedLabel.text = countModel.passedCars.description
		self.enteredLabel.text = countModel.enterCars.description
		
		let forecasts = countModel.forecasts?.allObjects as! [Forecast]
		for forecast in forecasts {
			switch forecast.fuel {
			case 3: self.ai80Label.text = forecast.value.description
			case 4: self.ai92Label.text = forecast.value.description
			case 1: self.ai95Label.text = forecast.value.description
			case 7: self.dtLabel.text = forecast.value.description
			default: break
			}
		}
		self.conversionLabel.text = countModel.conversion.description
		let coordinates = CLLocationCoordinate2DMake(CLLocationDegrees(countModel.latitude), CLLocationDegrees(countModel.longitude))
		let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 500, longitudinalMeters: 500)
		mapView.setRegion(region, animated: false)
		mapView.isScrollEnabled = false
		mapView.isZoomEnabled = false
    }
}
