//
//  SecureViewController.swift
//  LAMer
//
//  Created by Ludovico Loreti on 10/12/17.
//  Copyright © 2017 Ludovico Loreti. All rights reserved.
//

import UIKit

class SecureViewController: UIViewController {
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(self, selector:#selector(checkSecurity), name:
			NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
	}
	@objc func checkSecurity() {
		if (AuthenticationManager.sharedInstance.needsAuthentication) {
			self.dismiss(animated: true, completion: nil)
		}
	}
	deinit {
		NotificationCenter.default.removeObserver(self)
	}

}
