//
//  ViewController.swift
//  LAMer
//
//  Created by Ludovico Loreti on 07/11/17.
//  Copyright © 2017 Ludovico Loreti. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKLoginKit


class MenuViewController: UIViewController {
	
	@IBOutlet weak var loginButton: UIButton!
	
	@IBOutlet weak var signupButton: UIButton!
	
	
	@IBAction func FbLoginBtn(_ sender: UIButton) {
		let fbLoginManager = FBSDKLoginManager()
		fbLoginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) {
			(result, error) in
			if error != nil {
				print("Tentativo di login fallito!", error?.localizedDescription ?? error!)
				Utils.showAlert(title: "Errore consenso app Facebook", msg: (error?.localizedDescription)!, in: self)
				return
			} else  {
				guard let accessToken = FBSDKAccessToken.current() else {
					print("Impossibile prendere l'accessToken di Facebook. Accesso Fallito o interrotto dall'utente")
					return
				}
				print("Accesso a Facebook riuscito. Tentativo di collegamento con Firebase", result.debugDescription)
				let credenziali = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
				Auth.auth().signIn(with: credenziali) { (user, error) in
					if error != nil {
						print("Qualcosa è andato storto con l'autenticazione di Firebase con FaceBook.", error?.localizedDescription ?? error!)
						Utils.showAlert(title: "Errore Login w/Facebook", msg: (error?.localizedDescription)!, in: self)
						return
					}
					print("Loggato con successo a Firebase con FB", user ?? "")
					let uid = Auth.auth().currentUser?.uid ?? "ERROR_1337_lol"
					let db = dbRef.child("items").child(uid)
					db.observeSingleEvent(of: .value, with: { (snapshot) in
						let item = snapshot.value as? [String:AnyObject]
						if (snapshot.exists() == false) {
							print("Utente non registrato")
							FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, first_name, last_name, name, email"]).start { (connection, result, err) in
								if err != nil {
									print("Fallito nella richiesta desiderata", err!)
									Utils.showAlert(title: "Errore lettura dati FB", msg: (err?.localizedDescription)!, in: self)
									return
								} else if let data = (result as? [String : AnyObject]) {
									let fbname = "\(data["first_name"]!)\(data["last_name"]!)"
									print(data, fbname)
									// inserisco nel database sotto la collection ITEMS capitanato dall'UID dell'user
									// l'username autocreato dell'utente
									let userValues = ["username": fbname]
									db.updateChildValues(userValues, withCompletionBlock: {
										(err, ref) in
										if err != nil {
											print("Errore nell'aggiungere data al db!\n info: \(err!.localizedDescription)")
											Utils.showAlert(title: "Errore scrittura Firebase", msg: (err?.localizedDescription)!, in: self)
											return
										} else {
											print("Username riferito all'uid aggiunto al db! \(ref) \n \(userValues)")
											//self.dismiss(animated: true, completion: nil)
										}
									})
								} else {
									print("ERRORE INASPETTATO!");
									return
								}
							}
						} else {
							print("Utente già registrato", item!)
						}
					}) { (error) in
						print(">>> Errore nel FirebaseDatabase)", error)
					}
					self.performSegue(withIdentifier: "toHomeScreen", sender: self)
				}
			}
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Add the background gradient
		view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
		
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if Auth.auth().currentUser != nil {
			self.performSegue(withIdentifier: "toHomeScreen", sender: self)
		}
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		get {
			return .lightContent
		}
	}
	
}
