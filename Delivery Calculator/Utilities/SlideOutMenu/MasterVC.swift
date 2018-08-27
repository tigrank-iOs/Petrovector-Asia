//
//  MasterVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 27/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

class MasterVC: UIViewController, PageForMenuDelegate {
	
	enum MenuStatus {
		case menuOpen
		case menuClose
	}
	
	let pageContainerID = "PageContainer"
	let centerPanelOffset: CGFloat = 80.0
	var pageNC: PageNavigationController?
	var pageSubviewInSelfView: UIView?
	var currentState: MenuStatus = .menuClose {
		didSet {
			let shouldShowShadow = currentState != .menuClose
			showShadowForPage(shouldShowShadow)
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		setPageSubview()
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let menuVC = segue.destination as? MenuVC {
			menuVC.changePageDelegate = self
		}
		
		if let naviControl = segue.destination as? PageNavigationController {
			pageNC = naviControl
			
			if let currentPage = naviControl.topViewController as? PageVC {
				currentPage.delegate = self
			}
		}
	}
	
	func setPageSubview() {
		for subview in view.subviews {
			if subview.restorationIdentifier == pageContainerID {
				pageSubviewInSelfView = subview
			}
		}
	}
	
	func animatePageXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
		UIView.animate(withDuration: 0.6,
					   delay: 0,
					   usingSpringWithDamping: 0.8,
					   initialSpringVelocity: 0,
					   options: .curveEaseInOut, animations: { [weak self] in
						self?.pageSubviewInSelfView?.frame.origin.x = targetPosition
			}, completion: completion)
	}
	
	func showShadowForPage(_ shouldShowShadow: Bool) {
		if shouldShowShadow {
			pageNC?.view.layer.shadowOpacity = 0.8
		} else {
			pageNC?.view.layer.shadowOpacity = 0.0
		}
	}
	
	// MARK: - PageForMenuDelegate
	func changePage(to page: String) {
		pageNC?.updatePageOnScreen(page)
		showMenu()
	}
	
	func showMenu() {
		if currentState == .menuClose {
			currentState = .menuOpen
			animatePageXPosition(targetPosition: UIScreen.main.bounds.size.width - centerPanelOffset)
		} else {
			hideMenu()
		}
	}
	
	func hideMenu() {
		currentState = .menuClose
		animatePageXPosition(targetPosition: 0)
	}
}
