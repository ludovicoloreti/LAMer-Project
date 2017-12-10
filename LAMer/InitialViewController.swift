//
//  InitialViewController.swift
//  LAMer
//
//  Created by Ludovico Loreti on 07/11/17.
//  Copyright © 2017 Ludovico Loreti. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class InitialViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
	
    override func viewDidAppear(_ animated: Bool) {
//		view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        super.viewDidAppear(animated)
		if Auth.auth().currentUser != nil {
			print("Utente loggato vai diretto alla home!")
			self.performSegue(withIdentifier: "toHomeScreenDirectly", sender: self)
		}
		self.performSegue(withIdentifier: "toMenuScreen", sender: self)
     
		
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
}
