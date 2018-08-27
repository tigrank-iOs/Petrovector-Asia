//
//  WelcomeVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 27/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

class WelcomeVC: PageVC {
	
	@IBOutlet weak var greetingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		
		greetingLabel.text = "ДОБРО ПОЖАЛОВАТЬ, ТИГРАН"
		
		let delay = DispatchTime.now() + .seconds(1)
		DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
			self?.menuTapped()
		}
    }
}
