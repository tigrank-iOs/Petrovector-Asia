//
//  PageForMenuDelegate.swift
//  Delivery Calculator
//
//  Created by Тигран on 27/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import Foundation

protocol PageForMenuDelegate: class {
	func changePage(to page: String)
	func showMenu()
	func hideMenu()
}
