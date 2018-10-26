//
//  MenuVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 24/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

public class MenuVC: UIViewController {

	// MARK: - Variables
	weak var changePageDelegate: PageForMenuDelegate?

	private let buttonNames = ["Калькулятор", "Расчет пролива"]

	// MARK: - Outlets
	@IBOutlet weak private var avatar: UIImageView!
	@IBOutlet weak private var nameLabel: UILabel!
	@IBOutlet weak private var tableView: UITableView!

	@IBOutlet weak private var widthConstraint: NSLayoutConstraint!
	@IBOutlet weak private var heightConstraint: NSLayoutConstraint!

	// MARK: - VCLifeCycle
    override public func viewDidLoad() {
        super.viewDidLoad()

		self.view.backgroundColor = UIColor().brandBlue

		if (UIApplication.shared.keyWindow?.bounds.size.width)! <= CGFloat(320.0) {
			widthConstraint.constant = 104
			heightConstraint.constant = 104
		}

		avatar.image = UIImage(named: User().avatar)
		nameLabel.text = User().getFullName()

		avatar.layer.cornerRadius = widthConstraint.constant / 2
		avatar.layer.masksToBounds = true

		tableView.delegate = self
		tableView.dataSource = self
		configureTableView()
    }

	func configureTableView() {
		tableView.backgroundColor = UIColor().brandBlue
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		tableView.isScrollEnabled = false
	}

}

extension MenuVC: UITableViewDelegate, UITableViewDataSource {

	// MARK: - UITableViewDataSource
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return buttonNames.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
		cell.textLabel?.text = buttonNames[indexPath.row]
		return cell
	}

	// MARK: - UITableViewDelegate
	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.textLabel?.textColor = UIColor.white
		cell.backgroundColor = .clear
	}

	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView()
		view.backgroundColor = .white

		let label = UILabel()
		let text = NSAttributedString(string: "МЕНЮ", attributes: [.font: UIFont.boldSystemFont(ofSize: 30)])
		label.adjustsFontSizeToFitWidth = true
		label.attributedText = text
		label.textColor = UIColor().brandBlue
		label.frame = CGRect(x: 20, y: 5, width: 100, height: 45)
		view.addSubview(label)

		return view
	}

	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 60
	}

	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
