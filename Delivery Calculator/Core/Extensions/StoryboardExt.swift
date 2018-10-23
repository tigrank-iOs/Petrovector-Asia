//
//  StoryboardExt.swift
//  Delivery Calculator
//
//  Created by Тигран on 27/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

extension UIStoryboard {
	static func getViewController(_ id: String) -> UIViewController? {
		let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		return mainStoryboard.instantiateViewController(withIdentifier: id)
	}
}
