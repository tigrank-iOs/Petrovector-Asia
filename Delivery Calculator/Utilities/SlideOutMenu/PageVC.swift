//
//  PageVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 27/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

class PageVC: UIViewController {
	
	weak var delegate: PageForMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let menuBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(menuTapped))
		navigationItem.setLeftBarButton(menuBarButtonItem, animated: false)
    }
	
	@objc func menuTapped() {
		let rootView = navigationController?.viewControllers.first as? PageVC
		rootView?.delegate?.showMenu()
	}
}
