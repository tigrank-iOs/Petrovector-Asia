//
//  WelcomeVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 27/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

public class WelcomeVC: PageVC {

	@IBOutlet weak var greetingLabel: UILabel!

    override public func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()

		greetingLabel.text = "Добро пожаловать, \(User().firstName)"

		let delay = DispatchTime.now() + .milliseconds(500)
		DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
			self?.menuTapped()
		}
    }
}
