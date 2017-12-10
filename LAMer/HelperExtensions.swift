//
//  HelperExtensions.swift
//  LAMer
//
//  Created by Ludovico Loreti on 07/11/17.
//  Copyright © 2017 Ludovico Loreti. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

extension UIButton {
	
	private func imageWithColor(color: UIColor) -> UIImage {
		let rect = CGRect(x: 0.0,y: 0.0,width: 1.0,height: 1.0)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()
		
		context!.setFillColor(color.cgColor)
		context!.fill(rect)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image!
	}
	
	func setBackgroundColor(color: UIColor, forUIControlState state: UIControlState) {
		self.setBackgroundImage(imageWithColor(color: color), for: state)
	}
	
}

extension UIView {
	
	/**
	Adds a vertical gradient layer with two **UIColors** to the **UIView**.
	- Parameter topColor: The top **UIColor**.
	- Parameter bottomColor: The bottom **UIColor**.
	*/
	
	func addVerticalGradientLayer(topColor:UIColor, bottomColor:UIColor) {
		let gradient = CAGradientLayer()
		gradient.frame = self.bounds
		gradient.colors = [
			topColor.cgColor,
			bottomColor.cgColor
		]
		gradient.locations = [0.0, 1.0]
		gradient.startPoint = CGPoint(x: 0, y: 0)
		gradient.endPoint = CGPoint(x: 0, y: 1)
		self.layer.insertSublayer(gradient, at: 0)
	}
}

extension UITableView {
	
	/**
	Adds a vertical gradient layer with two **UIColors** to the **UIView**.
	- Parameter topColor: The top **UIColor**.
	- Parameter bottomColor: The bottom **UIColor**.
	*/
	
	func addGradientLayer(topColor:UIColor, bottomColor:UIColor) {
		let gradient = CAGradientLayer()
		gradient.frame = self.bounds
		gradient.colors = [
			topColor.cgColor,
			bottomColor.cgColor
		]
		gradient.locations = [0.0, 1.0]
		gradient.startPoint = CGPoint(x: 0, y: 0)
		gradient.endPoint = CGPoint(x: 0, y: 1)
		self.layer.insertSublayer(gradient, at: 0)
	}
}

extension UIViewController {
	class func displaySpinner(onView : UIView) -> UIView {
		let spinnerView = UIView.init(frame: onView.bounds)
		spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
		let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
		ai.startAnimating()
		ai.center = spinnerView.center
		
		DispatchQueue.main.async {
			spinnerView.addSubview(ai)
			onView.addSubview(spinnerView)
		}
		
		return spinnerView
	}
	
	class func removeSpinner(spinner :UIView) {
		DispatchQueue.main.async {
			spinner.removeFromSuperview()
		}
	}
	
	class func setTitle(image: UIImageView) -> UIImageView {
		image.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
		image.contentMode = .scaleAspectFit
		return image
	}
	
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
}

extension UIImage {
	func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(
			CGSize(width: self.size.width + insets.left + insets.right,
				   height: self.size.height + insets.top + insets.bottom), false, self.scale)
		let _ = UIGraphicsGetCurrentContext()
		let origin = CGPoint(x: insets.left, y: insets.top)
		self.draw(at: origin)
		let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return imageWithInsets
	}
	
	func imageWithColor(tintColor: UIColor) -> UIImage {
		let rect = CGRect(x: 0, y: 0, width: 30, height: 30)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
		tintColor.setFill()
		UIRectFill(rect)
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return image
	}
}


extension String{
	
	func isValidForUrl()->Bool{
		if(self.hasPrefix("https")) {
			return true
		}
		return false
	}
}


extension UIViewController {
	/* TOUCH ID & FACE ID */
	
	func authenticationWithTouchID(completion: @escaping (Bool) -> Void) {
		let localAuthenticationContext = LAContext()
		localAuthenticationContext.localizedFallbackTitle = "Usa il tuo codice"
		
		var authError: NSError?
		let reasonString = "Per accedere ai dati sicuri"
		
		if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
			localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) { success, evaluateError in
				if success {
					print("success!!!!")
					completion(true)
				} else {
					//TODO: User did not authenticate successfully, look at error and take appropriate action
					guard let error = evaluateError else {
						return
					}
					print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
					Utils.showAlert(title: "Errore di Autenticazione", msg: self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code), in: self)
					completion(false)
					//TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
					
				}
			}
		} else {
			guard let error = authError else {
				return
			}
			print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
			completion(false)
			
		}
	}
	
	func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
		var message = ""
		if #available(iOS 11.0, macOS 10.13, *) {
			switch errorCode {
			case LAError.biometryNotAvailable.rawValue:
				message = "Impossibile eseguire l'auth perchè il dispositivo non supporta l'autenticazione biometrica."
				
			case LAError.biometryLockout.rawValue:
				message = "Autenticazione impossibile perchè l'utente ha fatto troppi tentativi."
				
			case LAError.biometryNotEnrolled.rawValue:
				message = "Nessuna autenticazione possibile perchè l'utente non l'ha attivata sul suo device."
				
			default:
				message = "Nessun particolare errore trovato (in LAError Object)."
			}
		} else {
			switch errorCode {
			case LAError.touchIDLockout.rawValue:
				message = "Troppi tentativi falliti!"
				
			case LAError.touchIDNotAvailable.rawValue:
				message = "Autenticazione Biometrica non possibile su questo dispositivo!"
				
			case LAError.touchIDNotEnrolled.rawValue:
				message = "Autenticazione Biometrica non attivata sul dispositivo!"
				
			default:
				message = "Nessun particolare errore trovato (in LAError Object)."
			}
		}
		
		return message;
	}
	
	func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
		
		var message = ""
		
		switch errorCode {
			
		case LAError.authenticationFailed.rawValue:
			message = "L'utente ha fallito nel fornire valide credenziali!"
			
		case LAError.appCancel.rawValue:
			message = "Autenticazione rimossa dall'Applicazione stessa."
			
		case LAError.invalidContext.rawValue:
			message = "Contesto invalido (invalidContext)."
			
		case LAError.notInteractive.rawValue:
			message = "Non interattivo (notInteractive)."
			
		case LAError.passcodeNotSet.rawValue:
			message = "PIN non settato sul dispositivo."
			
		case LAError.systemCancel.rawValue:
			message = "Autenticazione rimossa dal sistema stesso."
			
		case LAError.userCancel.rawValue:
			message = "L'utente ha annullato l'azione di autenticazione"
			
		case LAError.userFallback.rawValue:
			message = "L'utente ha scelto il fallback"
			
		default:
			message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
		}
		
		return message
	}
	/* END TOUCH ID & FACE ID */
}






