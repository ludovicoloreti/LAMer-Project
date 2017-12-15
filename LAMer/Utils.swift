//
//  utils.swift
//  LAMer
//
//  Created by Ludovico Loreti on 06/12/17.
//  Copyright © 2017 Ludovico Loreti. All rights reserved.
//

import Foundation
import UIKit
import RNCryptor

class Utils {
	
	/// Prende un url e ritorna un oggetto di tipo UIImage (che non è UIImageView)
	///
	/// - Parameter urlImg: stringa contentente un url
	/// - Returns: Immagine da inserire poi in una UIImageView
	static func imageFromUrl(urlImg: String) -> UIImage {
		var finalImg = UIImage().imageWithColor(tintColor: secondaryColor)
		if urlImg.isValidForUrl() {
			let url = URL(string: "\(urlImg)")
			let data = try? Data(contentsOf: url!)
			let img = UIImage(data: data!)!
			finalImg = img
		} else {
			let img = UIImage(named: "defaultIcon")?.imageWithColor(tintColor: secondaryColor)
			finalImg = img!
		}
		return finalImg
	}
	
	/// Mostra un alert semplice
	///
	/// - Parameters:
	///   - title: Titolo alert
	///   - msg: Messaggio alert
	static func showAlert(title: String, msg: String, in vc: UIViewController) {
		DispatchQueue.main.async {
			let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
			let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
			alertController.addAction(okayAction)
			vc.present(alertController, animated: true, completion: nil)
		}
	}
	
	/// Casi di ConfirmResult Action usati nella func sucessiva
	///
	/// - success: se va a buon fine
	/// - cancel: se non va a buon fine o è stato annullato
	enum ConfirmResultAction {
		case success(Bool)
		case cancel(Bool)
	}
	
	/// Mostra un alert con due tasti, quindi con due azioni possibili
	///
	/// - Parameters:
	///   - title: titolo alert
	///   - msg: messaggio alert
	///   - okBtnTxt: testo del bottone con azione collegata
	///   - completion: success o cancel (boolean)
	static func showConfirm(title: String, msg: String, okBtnTxt: String, in vc: UIViewController, completion: @escaping (ConfirmResultAction) -> ()){
		DispatchQueue.main.async {
			let confirmAlert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
			confirmAlert.addAction(UIAlertAction(title: okBtnTxt, style: .destructive, handler: {(confirmAlert: UIAlertAction!) in completion(.success(true))}))
			confirmAlert.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: {(confirmAlert: UIAlertAction!) in completion(.cancel(true))}))
			vc.present(confirmAlert, animated: true, completion: nil)
		}
		
	}
	
	/// Cripta un messaggio grazie ad una chiave fornita
	///
	/// - Parameters:
	///   - message: Messaggio da criptare
	///   - encryptionKey: chiave di criptazione
	/// - Returns: Stringa criptata
	static func encryptMessage(message: String, encryptionKey: String) throws -> String {
		let messageData = message.data(using: .utf8)!
		let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
		print("\n\n\n", cipherData, "\n\n\n")
		return cipherData.base64EncodedString()
	}
	
	/// Decripta un messaggio grazie alla chiave fornita per criptarlo
	///
	/// - Parameters:
	///   - encryptedMessage: Messaggio criptato
	///   - encryptionKey: chiave di criptazione
	/// - Returns: Stringa decriptata
	static func decryptMessage(encryptedMessage: String, encryptionKey: String) throws -> String {
		
		let encryptedData = Data.init(base64Encoded: encryptedMessage)!
		let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: encryptionKey)
		let decryptedString = String(data: decryptedData, encoding: .utf8)!
		
		return decryptedString
	}
	
	static func openApp(uri: String) -> Bool {
		if #available(iOS 10.0, *) {
			let url = NSURL(string:uri)! as URL
			if UIApplication.shared.canOpenURL(url) {
				UIApplication.shared.open(url)
				return true
			} else {
				return false
			}
		} else {
			return false
		}
	}
	
	
}

class TextField: UITextField {
	
	let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, padding)
	}
	
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, padding)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, padding)
	}
}

class PaddingLabel: UILabel {
	
	@IBInspectable var topInset: CGFloat = 20.0
	@IBInspectable var bottomInset: CGFloat = 20.0
	@IBInspectable var leftInset: CGFloat = 5.0
	@IBInspectable var rightInset: CGFloat = 5.0
	
	override func drawText(in rect: CGRect) {
		let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
		super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
	}
	
	override var intrinsicContentSize: CGSize {
		get {
			var contentSize = super.intrinsicContentSize
			contentSize.height += topInset + bottomInset
			contentSize.width += leftInset + rightInset
			return contentSize
		}
	}
}

/* Auth Stuff (per la condivisione tra le varie view) */
class AuthenticationManager {
	static let sharedInstance = AuthenticationManager()
	var needsAuthentication = false
}
