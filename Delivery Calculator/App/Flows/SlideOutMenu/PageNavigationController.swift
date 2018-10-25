//
//  PageNavigationController.swift
//  Delivery Calculator
//
//  Created by Тигран on 27/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

class PageNavigationController: UINavigationController {

	func updatePageOnScreen(_ page: String) {
		if topViewController?.restorationIdentifier != page {
			if viewControllers.count > 1 {
				popViewController(animated: false)
			}
			if let newPage = UIStoryboard.getViewController(page) as? PageVC {
				pushViewController(newPage, animated: false)
			}
		}
	}

}
