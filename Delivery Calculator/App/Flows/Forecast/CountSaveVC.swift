//
//  CountSaveVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 28/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import MapKit

protocol CountSaveProtocol: class {
	func didSaveModel(_ model: CountModel)
}

class CountSaveVC: UIViewController {

	// MARK: - Variables
	private let locationManager = CLLocationManager()
	private let myPointAnnotation = MKPointAnnotation()
	private var azsType: StationTypes?
	var countModel: CountModel!
	weak var delegate: CountSaveProtocol?

	// MARK: - Outlets
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var dropDownMenuButton: UIButton!
	@IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var startLabel: UILabel!
	@IBOutlet weak var stopLabel: UILabel!
	@IBOutlet weak var passedLabel: UILabel!
	@IBOutlet weak var enterLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var mapView: MKMapView!

	// MARK: - VCLifeCycle
	override func viewDidLoad() {
        super.viewDidLoad()
		setupMapView()
		setupLocationManager()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupLabels()
	}

	// MARK: - Functions
	fileprivate func setupMapView() {
		mapView.delegate = self
	}

	fileprivate func setupLocationManager() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()

		if let currentLocation = locationManager.location?.coordinate {
			myPointAnnotation.title = ""
			myPointAnnotation.coordinate = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude)
			mapView.addAnnotation(myPointAnnotation)
		}
	}

	fileprivate func setupLabels() {
		nameLabel.text = countModel.name
		dayLabel.text = countModel.dayOfWeek
		startLabel.text = DateConverter().getHoursMinutes(Date(timeIntervalSince1970: countModel.timeStart))
		stopLabel.text = DateConverter().getHoursMinutes(Date(timeIntervalSince1970: countModel.timeStop))
		passedLabel.text = countModel.passedCars.description
		enterLabel.text = countModel.enterCars.description
	}

	fileprivate func showEmptyTypeAlert() {
		let alert = UIAlertController(title: "Ошибка", message: "Пожалуйста, выберите тип АЗС", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ок", style: .default)
		alert.addAction(okAction)
		self.present(alert, animated: true)
	}
	
	// MARK: - Actions
	@IBAction func savePressed(_ sender: UIButton) {
		let location = myPointAnnotation.coordinate
		guard let type = azsType else {
			showEmptyTypeAlert()
			return
		}
		countModel.setValue(Float(location.latitude), forKey: "latitude")
		countModel.setValue(Float(location.longitude), forKey: "longitude")
		let results = ForecastEngine().makeForecast(for: countModel)
		for result in results {
			if let key = result.key as? Int {
				let fuel: Fuels = Fuels(rawValue: key)!
				let forecast = Forecast()
				forecast.setValue(fuel.rawValue, forKey: "fuel")
				forecast.setValue(result.value, forKey: "value")
				forecast.setValue(countModel, forKey: "countModel")
				countModel.addToForecasts(forecast)
			} else {
				countModel.setValue(result.value, forKey: "conversion")
			}
		}
		CoreDataManager.shared.saveContext()
	}
	
	@IBAction func dropDownPressed(_ sender: UIButton) {
		guard let popVC = UIStoryboard.getViewController("popVC") as? AZSTypesPopover else { return }
		popVC.modalPresentationStyle = .popover
		popVC.delegate = self
		let popoverVC = popVC.popoverPresentationController
		popoverVC?.delegate = self
		popoverVC?.sourceView = dropDownMenuButton
		popoverVC?.sourceRect = CGRect(x: dropDownMenuButton.bounds.midX,
									   y: dropDownMenuButton.bounds.midY + 44,
									   width: 0,
									   height: 0)
		
		popoverVC?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
		popVC.preferredContentSize = CGSize(width: dropDownMenuButton.bounds.width, height: 88)
		
		self.present(popVC, animated: true)
	}

	// MARK: - Navigation
	override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
		if identifier == "unwindSegue" {
			if azsType == nil {
				return false
			}
		}
		return true
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "unwindSegue" {
			let forecastVC = segue.destination as! ForecastVC
			self.delegate = forecastVC
			delegate?.didSaveModel(countModel)
		}
	}
}

extension CountSaveVC: MKMapViewDelegate {

	// MARK: - MKMapViewDelegate
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		return MKTileOverlayRenderer(overlay: overlay)
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard !(annotation is MKUserLocation) else {
			return nil
		}

		let annotationIdentifier = "MyPointAnnotation"

		var annotationView: MKAnnotationView?
		if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
			annotationView = dequeuedAnnotationView
			annotationView?.annotation = annotation
		} else {
			annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
			annotationView?.rightCalloutAccessoryView = nil
		}

		if let annotationView = annotationView {
			annotationView.canShowCallout = false
			annotationView.image = UIImage()
		}

		return annotationView
	}

	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		let regionCenter = mapView.region.center
		myPointAnnotation.coordinate = CLLocationCoordinate2DMake(regionCenter.latitude, regionCenter.longitude)
		let location = CLLocation(latitude: regionCenter.latitude, longitude: regionCenter.longitude)
		let coder = CLGeocoder()
		coder.reverseGeocodeLocation(location) { [weak self] places, _ in
			guard let strongSelf = self else { return }
			if let selectedPlace = places?.first {

				guard let street = selectedPlace.addressDictionary?["Street"] as? String,
					  let city = selectedPlace.addressDictionary?["City"] as? String else { return }

				let fullAdress = "\(city), \(street)"
				strongSelf.locationLabel.text = fullAdress
			}
		}
	}
}

extension CountSaveVC: CLLocationManagerDelegate {

	// MARK: - CLLocationManagerDelegate
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let currentLocation = locations.last?.coordinate {
			let coordinate = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
			let coder = CLGeocoder()
			coder.reverseGeocodeLocation(coordinate) { [weak self] placemarks, _ in
				guard let strongSelf = self else { return }
				if let myPlace = placemarks?.first {

					guard let street = myPlace.addressDictionary?["Street"] as? String,
						  let city = myPlace.addressDictionary?["City"] as? String else { return }

					let fullAdress = "\(city), \(street)"
					strongSelf.locationLabel.text = fullAdress
				}
			}

			let currentRadius: CLLocationDistance = 1000
			let currentRegion = MKCoordinateRegion.init(center: currentLocation,
														latitudinalMeters: currentRadius * 2,
														longitudinalMeters: currentRadius * 2)

			mapView.setRegion(currentRegion, animated: false)
			mapView.showsUserLocation = true
			locationManager.stopUpdatingLocation()
		}
	}
}

extension CountSaveVC: UIPopoverPresentationControllerDelegate {
	
	// MARK: - UIPopoverPresentationControllerDelegate
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none
	}
}

extension CountSaveVC: AZSTypesPopoverDelegate {

	// MARK: - AZSTypesPopoverDelegate
	func didSelectType(_ type: StationTypes) {
		switch type {
		case .city:
			azsType = .city
			let title = NSAttributedString(string: "Город",
										   attributes: [.font: UIFont.systemFont(ofSize: 20), .foregroundColor: UIColor.black])

			dropDownMenuButton.setAttributedTitle(title, for: .normal)
			countModel.setValue(type.rawValue, forKey: "azsType")
		case .highway:
			azsType = .highway
			let title = NSAttributedString(string: "Трасса",
										   attributes: [.font: UIFont.systemFont(ofSize: 20), .foregroundColor: UIColor.black])

			dropDownMenuButton.setAttributedTitle(title, for: .normal)
			countModel.setValue(type.rawValue, forKey: "azsType")
		}
	}
}
