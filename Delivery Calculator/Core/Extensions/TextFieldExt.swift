//
//  TextFieldExt.swift
//  Delivery Calculator
//
//  Created by Тигран on 24/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

extension UITextField {
	func setBottomBorder() {
		self.borderStyle = .none
		self.layer.backgroundColor = UIColor.white.cgColor

		self.layer.masksToBounds = false
		self.layer.shadowColor = UIColor.lightGray.cgColor
		self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
		self.layer.shadowOpacity = 1.0
		self.layer.shadowRadius = 0.0
	}
}
