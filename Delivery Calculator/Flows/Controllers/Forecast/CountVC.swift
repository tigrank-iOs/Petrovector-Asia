//
//  CountVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 28/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

enum StartStopButtonState {
	case start
	case stop
}

enum CancelSaveButtonState {
	case cancel
	case save
}

class CountVC: UIViewController {

	// MARK: - Variables
	var countModel: CountModel?
	var startStopState: StartStopButtonState = .start
	var cancelSaveState: CancelSaveButtonState = .cancel {
		didSet {
			switch cancelSaveState {
			case .cancel:
				cancelSaveButton.setTitle("Отменить", for: .normal)
			case .save:
				cancelSaveButton.setTitle("Сохранить", for: .normal)
			}
		}
	}
	var mainCount = 0 {
		didSet {
			mainCounter.text = mainCount.description
		}
	}
	var additionalCount = 0 {
		didSet {
			additionalCounter.text = additionalCount.description
		}
	}

	var timeOfStart: TimeInterval?
	var timeOfStop: TimeInterval?

	// MARK: - Outlets
	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var startStopButton: UIButton!
	@IBOutlet weak var startLabel: UILabel!
	@IBOutlet weak var stopLabel: UILabel!
	@IBOutlet weak var mainCounter: UILabel!
	@IBOutlet weak var additionalCounter: UILabel!
	@IBOutlet weak var cancelSaveButton: UIButton!
	@IBOutlet weak var countStackView: UIStackView!

	// MARK: - VCLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

		countStackView.isHidden = true
		nameField.becomeFirstResponder()

		let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
		hideKeyboardGesture.cancelsTouchesInView = false
		self.view.addGestureRecognizer(hideKeyboardGesture)
    }

	// MARK: - Actions
	@IBAction func startStopPressed(_ sender: UIButton) {
		switch startStopState {
		case .start:
			startStopState = .stop
			changeStartStopButton()
			changeCancelSaveButton(.start)
			let date = Date()
			timeOfStart = date.timeIntervalSince1970
			startLabel.text = "Старт: \(DateConverter().getHoursMinutes(date))"
		case .stop:
			changeCancelSaveButton(.stop)
			let date = Date()
			timeOfStop = date.timeIntervalSince1970
			stopLabel.text = "Стоп: \(DateConverter().getHoursMinutes(date))"
			startStopButton.isEnabled = false
		}
	}

	@IBAction func mainPlusPressed(_ sender: UIButton) {
		mainCount += 1

	}

	@IBAction func mainMinusPressed(_ sender: UIButton) {
		guard mainCount > 0 else { return }
		mainCount -= 1
	}

	@IBAction func additionalPlusPressed(_ sender: UIButton) {
		additionalCount += 1
	}

	@IBAction func additionalMinusPressed(_ sender: UIButton) {
		guard additionalCount > 0 else { return }
		additionalCount -= 1
	}

	@IBAction func cancelSavePressed(_ sender: UIButton) {
		switch cancelSaveState {
		case .cancel:
			self.dismiss(animated: true, completion: nil)
		case .save:
			guard let name = nameField.text, let start = timeOfStart, let stop = timeOfStop else { return }
			guard name != "" else {
				showEmptyNameAlert()
				return
			}
			countModel = CountModel(name: name,
									month: DateConverter().getMonth(Date()),
									day: DateConverter().getDayOfWeek(Date()),
									start: start,
									stop: stop,
									passed: mainCount,
									enter: additionalCount)

			performSegue(withIdentifier: "saveCount", sender: self)
		}
	}

	// MARK: - Functions
	func changeStartStopButton() {
		startStopButton.setTitle("Стоп", for: .normal)
		startStopButton.backgroundColor = UIColor.red
	}

	func changeCancelSaveButton(_ whenPressed: StartStopButtonState) {
		switch whenPressed {
		case .start:
			cancelSaveButton.isHidden = true
			countStackView.isHidden = false
		case .stop:
			cancelSaveButton.isHidden = false
			countStackView.isHidden = true
			cancelSaveState = .save
		}
	}

	func showEmptyNameAlert() {
		let alert = UIAlertController(title: "Ошибка", message: """
Поле "Название" не может быть пустым
""", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ок", style: .default)
		alert.addAction(okAction)
		self.present(alert, animated: true)
	}

	@objc func hideKeyboard() {
		self.view.endEditing(true)
	}

	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "saveCount" {
			let destVC = segue.destination as! CountSaveVC
			destVC.countModel = countModel
		}
	}
}
