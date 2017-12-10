//
//  AuthViewController.swift
//  LAMer
//
//  Created by Ludovico Loreti on 10/12/17.
//  Copyright © 2017 Ludovico Loreti. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class AuthViewController: SecureViewController {
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
		navigationController?.navigationBar.isTranslucent = false
		navigationController?.navigationBar.barTintColor = primaryColor
		navigationController?.navigationBar.tintColor = UIColor.white;
		self.navigationItem.titleView = UIViewController.setTitle(image: UIImageView(image: #imageLiteral(resourceName: "logo")))
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		authenticationWithTouchID(completion: { (success) in
			if success {
				UIViewController.displaySpinner(onView: self.view)
				DispatchQueue.main.async {
					self.performSegue(withIdentifier: "toAuthenticatedView", sender: self)
				}
			} else {
				self.dismiss(animated: false, completion: nil)
			}
		})
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		self.dismiss(animated: false, completion: nil)
	}
	
}
