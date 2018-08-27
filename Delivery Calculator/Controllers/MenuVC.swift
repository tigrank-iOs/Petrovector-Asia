//
//  MenuVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 24/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
	
	// MARK: - Variables
	weak var changePageDelegate: PageForMenuDelegate?
	
	let buttonNames = ["Калькулятор", "Расчет пролива"]
	
	// MARK: - Outlets
	@IBOutlet weak var avatar: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
		
		//Заглушка. Вынести отдельный класс юзера
		avatar.image = UIImage(named: "avatar")
		nameLabel.text = "Tigran Khachaturian"
		
		//Заглушка. Вынести в отдельный класс круглое изображение.
		avatar.layer.cornerRadius = avatar.frame.width / 2
		avatar.layer.masksToBounds = true

		tableView.delegate = self
		tableView.dataSource = self
		configureTableView()
    }
	
	func configureTableView() {
		tableView.backgroundColor = UIColor(displayP3Red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		tableView.isScrollEnabled = false
	}

}

extension MenuVC: UITableViewDelegate, UITableViewDataSource {
	
	// MARK: - UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return buttonNames.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
		cell.textLabel?.text = buttonNames[indexPath.row]
		return cell
	}
	
	// MARK: - UITableViewDelegate
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.textLabel?.textColor = UIColor.white
		cell.backgroundColor = .clear
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		view.backgroundColor = .white
		
		let label = UILabel()
		let text = NSAttributedString(string: "МЕНЮ", attributes: [.font : UIFont.boldSystemFont(ofSize: 30)])
		label.attributedText = text
		label.textColor = UIColor(displayP3Red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
		label.frame = CGRect(x: 20, y: 5, width: 100, height: 45)
		view.addSubview(label)
		
		return view
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 60
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.row {
		case 0:
			changePageDelegate?.changePage(to: "CalculatorVC")
		case 1:
			changePageDelegate?.changePage(to: "CountVC")
		default:
			print("Unknown")
		}
	}
	
}
