//
//  ItemDetailViewController.swift
//  LAMer
//
//  Created by Ludovico Loreti on 05/12/17.
//  Copyright © 2017 Ludovico Loreti. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FBSDKLoginKit

class ItemDetailViewController: SecureViewController {
	
	var item:Item?
	
	@IBOutlet weak var deleteBtn: UIButton!
	@IBOutlet weak var serviceLbl: PaddingLabel!
	@IBOutlet weak var usernameLbl: PaddingLabel!
	@IBOutlet weak var passwordLbl: PaddingLabel!
	@IBOutlet weak var copyPasswdBtn: UIButton!
	@IBOutlet weak var iconImage: UIImageView!
	
	@IBOutlet weak var myGradientView: UIView!
    
    @IBOutlet weak var srvLbl: PaddingLabel!
    @IBOutlet weak var usrnmLbl: PaddingLabel!
    @IBOutlet weak var pwdLbl: PaddingLabel!
    
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// se utente non loggato torna all'inizio
		if Auth.auth().currentUser?.uid == nil {
			self.dismiss(animated: false, completion: nil)
		}
		// aggiungo un gradient alla view che ho predisposto per tale scopo
		myGradientView.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
		self.title = item?.service
		serviceLbl.text = item?.service
		usernameLbl.text = item?.username
		passwordLbl.text = try! Utils.decryptMessage(encryptedMessage: (self.item?.password)!, encryptionKey: (self.item?.id)!)
		iconImage.image = Utils.imageFromUrl(urlImg: (item?.icon)!).imageWithInsets(insets: UIEdgeInsetsMake(30, 30, 30, 30))
		iconImage.layer.cornerRadius = 5
		serviceLbl.layer.masksToBounds = true
		serviceLbl.layer.cornerRadius = 5
		usernameLbl.layer.masksToBounds = true
		usernameLbl.layer.cornerRadius = 5
		passwordLbl.layer.masksToBounds = true
		passwordLbl.layer.cornerRadius = 5
		// se la pwd non è presente (non so il motivo, mi andava di scriverlo) allora nascondo il bottone per copiarla..
		if item?.password == nil {
			copyPasswdBtn.isHidden = true
			passwordLbl.text = "Nessuna password impostata"
		}
		
	}
	
	// azione sul click del bottone "copia pwd"
	@IBAction func CopyPwd(_ sender : UIButton) {
		let pasteboard = UIPasteboard.general
		pasteboard.string = try! Utils.decryptMessage(encryptedMessage: (self.item?.password)!, encryptionKey: (self.item?.id)!)
		if pasteboard.string != nil {
			print("pwd copiata")
			Utils.showAlert(title: "Completato", msg: "Password copiata con successo!", in: self)
		}
	}
	
	@IBAction func deleteHandler(_ sender: UIButton) {
		Utils.showConfirm(title: "Elimina", msg: "Sicuro di voler rimuovere questo account?", okBtnTxt: "Rimuovi", in: self) { confirmResultAction in
			switch confirmResultAction {
			case .success(true):
				dbRef.child("items").child((Auth.auth().currentUser?.uid)! ).child("data").child((self.item?.id)!).removeValue(completionBlock: {
					(error, ref) in
					if error != nil {
						Utils.showAlert(title: "Errore rimozione dal DB", msg: (error?.localizedDescription)!, in: self)
						print(error?.localizedDescription as Any)
					} else {
						print(ref)
						Utils.showAlert(title: "Rimosso!", msg: "Account rimosso correttamente!", in: self)
					}
				})
				self.dismiss(animated: false, completion: nil)
				break
			case .cancel(true):
				print("Annullato")
				break
			default:
				break
			}
		}		
	}
	
}

