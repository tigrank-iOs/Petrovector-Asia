//
//  AZSTypesPopover.swift
//  Delivery Calculator
//
//  Created by Тигран on 29/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

protocol AZSTypesPopoverDelegate: class {
	func didSelectType(_ type: StationTypes)
}

class AZSTypesPopover: UITableViewController {

	weak var delegate: AZSTypesPopoverDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.dismiss(animated: true) {
			switch indexPath.row {
			case 0:
				self.delegate?.didSelectType(.city)
			case 1:
				self.delegate?.didSelectType(.highway)
			default:
				print("Now such row")
			}
		}
	}
}
