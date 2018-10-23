//
//  LoginVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 24/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

public class LoginVC: UIViewController {

	@IBOutlet weak var login: UITextField!
	@IBOutlet weak var password: UITextField!

	override public func viewDidLoad() {
        super.viewDidLoad()

		login.setBottomBorder()
		password.setBottomBorder()
    }

	@IBAction func loginButtonPressed(_ sender: UIButton) {
		performSegue(withIdentifier: "Login", sender: nil)
	}

}
