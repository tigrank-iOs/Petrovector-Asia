//
//  LoginVC.swift
//  Delivery Calculator
//
//  Created by Тигран on 24/08/2018.
//  Copyright © 2018 PetrovectorGroup. All rights reserved.
//

import UIKit

public class LoginVC: UIViewController {

	// MARK: - Outlets
	@IBOutlet weak var login: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var scrollView: UIScrollView!

	// MARK: - VCLifeCycle
	override public func viewDidLoad() {
        super.viewDidLoad()
		
		login.delegate = self
		password.delegate = self

		login.setBottomBorder()
		password.setBottomBorder()
    }
	
	override public func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(self.keyboardWasShown(notification:)),
											   name: UIResponder.keyboardWillShowNotification,
											   object: nil)
		
		NotificationCenter.default.addObserver(self,
											   selector: #selector(self.keyboardWillBeHidden(notification:)),
											   name: UIResponder.keyboardWillHideNotification,
											   object: nil)
		
		login.becomeFirstResponder()
	}
	
	override public func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	// MARK: - OBJC Functions
	@objc func keyboardWasShown(notification: Notification) {
		let info = notification.userInfo! as NSDictionary
		let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
		let contentInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
		
		scrollView?.contentInset = contentInsets
		scrollView?.scrollIndicatorInsets = contentInsets
		
		if Int(UIScreen.main.bounds.size.height) <= 568 {
			scrollView.isScrollEnabled = true
		}
	}
	
	@objc func keyboardWillBeHidden(notification: Notification) {
		let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		scrollView?.contentInset = contentInsets
		scrollView?.scrollIndicatorInsets = contentInsets
		
		scrollView.bounds = CGRect(x: 0.0, y: 0.0, width: scrollView.bounds.width, height: scrollView.bounds.height)
		
		scrollView.isScrollEnabled = false
	}
	
	@objc func hideKeyboard() {
		self.scrollView?.endEditing(true)
		
		scrollView.bounds = CGRect(x: 0.0, y: 0.0, width: scrollView.bounds.width, height: scrollView.bounds.height)
		
		scrollView.isScrollEnabled = false
		self.loginButtonPressed(self)
	}

	// MARK: - Actions
	@IBAction func loginButtonPressed(_ sender: Any) {
		performSegue(withIdentifier: "Login", sender: nil)
	}
}

extension LoginVC: UITextFieldDelegate {
	
	// MARK: - UITextFieldDelegate
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == login {
			password.becomeFirstResponder()
		} else {
			loginButtonPressed(self)
		}
		return true
	}
}
