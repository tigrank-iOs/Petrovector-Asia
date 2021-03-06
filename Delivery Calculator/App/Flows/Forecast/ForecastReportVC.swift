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
	@IBOutlet weak var azsTypeLabel: UILabel!
	@IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var passedLabel: UILabel!
	@IBOutlet weak var enteredLabel: UILabel!
	@IBOutlet weak var ai80Label: UILabel!
	@IBOutlet weak var ai92Label: UILabel!
	@IBOutlet weak var ai95Label: UILabel!
	@IBOutlet weak var dtLabel: UILabel!
	@IBOutlet weak var overallLabel: UILabel!
	@IBOutlet weak var conversionLabel: UILabel!
	
	@IBOutlet weak var mapView: MKMapView!
	
	// MARK: - VCLifeCycle
	override func viewDidLoad() {
        super.viewDidLoad()
		
		setData()
		setMap()
    }
	
	// MARK: - Private Functions
	private func setData() {
		self.navigationItem.title = countModel.name
		self.azsTypeLabel.text = countModel.azsType
		self.dayLabel.text = countModel.dayOfWeek
		self.passedLabel.text = countModel.passedCars.description
		self.enteredLabel.text = countModel.enterCars.description
		
		let forecasts = countModel.forecasts?.allObjects as! [Forecast]
		var overall = 0.0
		for forecast in forecasts {
			switch forecast.fuel {
			case 3: self.ai80Label.text = forecast.value.formattedWithSeparator; overall += forecast.value
			case 4: self.ai92Label.text = forecast.value.formattedWithSeparator; overall += forecast.value
			case 1: self.ai95Label.text = forecast.value.formattedWithSeparator; overall += forecast.value
			case 7: self.dtLabel.text = forecast.value.formattedWithSeparator; overall += forecast.value
			default: break
			}
		}
		self.overallLabel.text = (Double(Int(overall * 100)) / 100).formattedWithSeparator
		self.conversionLabel.text = countModel.conversion.description
	}
	
	private func setMap() {
		let coordinates = CLLocationCoordinate2DMake(CLLocationDegrees(countModel.latitude), CLLocationDegrees(countModel.longitude))
		let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 500, longitudinalMeters: 500)
		mapView.setRegion(region, animated: false)
		mapView.delegate = self
		myPointAnnotation.coordinate = coordinates
		mapView.addAnnotation(myPointAnnotation)
		
		let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
		let coder = CLGeocoder()
		coder.reverseGeocodeLocation(location) { [weak self] places, _ in
			guard let strongSelf = self else { return }
			if let selectedPlace = places?.first {
				
				guard let street = selectedPlace.addressDictionary?["Street"] as? String,
					let city = selectedPlace.addressDictionary?["City"] as? String else { return }
				
				let fullAdress = "\(city), \(street)"
				strongSelf.myPointAnnotation.title = fullAdress
			}
		}
	}
}

extension ForecastReportVC: MKMapViewDelegate {
	
	// MARK: - MKMapViewDelegate
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		return MKTileOverlayRenderer(overlay: overlay)
	}
}
