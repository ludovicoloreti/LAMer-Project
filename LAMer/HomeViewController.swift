//
//  HomeViewController.swift
//  LAMer
//
//  Created by Ludovico Loreti on 30/11/17.
//  Copyright © 2017 Ludovico Loreti. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FBSDKLoginKit
import LocalAuthentication

class HomeViewController: SecureViewController, UITableViewDataSource {

	var items = [Item]()
	@IBOutlet weak var content: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if Auth.auth().currentUser?.uid == nil {
			self.dismiss(animated: false, completion: nil)
		} 
        graphicStuff()
		getDataFromFirebase()
		//content.tableFooterView = UIView()
	}
	
	func graphicStuff() {
		navigationController?.navigationBar.isTranslucent = false
		navigationController?.navigationBar.barTintColor = primaryColor
		navigationController?.navigationBar.tintColor = UIColor.white;
		self.navigationItem.titleView = UIViewController.setTitle(image: UIImageView(image: #imageLiteral(resourceName: "logo")))
		content.backgroundColor = UIColor.white
	}
	
	func getDataFromFirebase() {
		let sv = UIViewController.displaySpinner(onView: self.view)
		let uid = Auth.auth().currentUser?.uid ?? "ERROR_1337_lol"
		let db = dbRef.child("items").child(uid).child("data")
		db.observe(.value, with: { (snapshot) in
			guard let itemData = snapshot.children.allObjects as? [DataSnapshot] else {return}
			print(snapshot.key)
			if (snapshot.exists() == false) {
				UIViewController.removeSpinner(spinner: sv)
				Utils.showAlert(title: "Nessun Dato", msg: "Nessun dato presente nel Database di Firebase!", in: self)
				return
			} else {
				for child in itemData {
					guard let id = child.childSnapshot(forPath: "id").value as? String else {
						Utils.showAlert(title: "Erroe campo ID", msg: "Errore nel campo ID, contattare amministratore!", in: self)
						return
					}
					guard let service = child.childSnapshot(forPath: "service").value as? String else {
						Utils.showAlert(title: "Erroe campo Service", msg: "Errore nel campo SERVICE (Account), contattare amministratore!", in: self)
						return
					}
					guard let icon = child.childSnapshot(forPath: "icon").value as? String else {
						Utils.showAlert(title: "Erroe campo Icon", msg: "Errore nel campo ICON, contattare amministratore!", in: self)
						return
					}
					guard let username = child.childSnapshot(forPath: "username").value as? String else {
						Utils.showAlert(title: "Erroe campo username", msg: "Errore nel campo USERNAME, contattare amministratore!", in: self)
						return
					}
					guard let password = child.childSnapshot(forPath: "password").value as? String else {
						Utils.showAlert(title: "Erroe campo password", msg: "Errore nel campo PASSWORD, contattare amministratore!", in: self)
						return
					}
					let item = Item(id: id, service: service, icon: icon, username: username, password: password)
					self.items.append(item)
				}
				UIViewController.removeSpinner(spinner: sv)
				print(self.items)
				DispatchQueue.main.async {
					self.content.reloadData()
				}
			}
		})
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemCell else { return UITableViewCell() }
		cell.serviceLabel.text = items[indexPath.row].service
		cell.usernameLabel.text = items[indexPath.row].username
		cell.imgView.image = Utils.imageFromUrl(urlImg: items[indexPath.row].icon)
		cell.imgView.image = cell.imgView.image?.imageWithInsets(insets: UIEdgeInsetsMake(10,10,10,10))
		return cell
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
		selectedCell.contentView.backgroundColor = secondaryColor
		performSegue(withIdentifier: "showItemDetail", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let destination = segue.destination as? ItemDetailViewController {
			destination.item = items[(content.indexPathForSelectedRow?.row)!]
		}
		let backItem = UIBarButtonItem()
		backItem.title = ""
		navigationItem.backBarButtonItem = backItem
	}
	
	func LogOut() {
		if FBSDKAccessToken.current() != nil {
			FBSDKLoginManager().logOut()
		}
		// continua..
		//		do {
		try! Auth.auth().signOut()
		//		} catch let erroreLoggingOut {
		//			print("Errore durante il logout! \(erroreLoggingOut)")
		//		}
		self.dismiss(animated: false, completion: nil)
	}
	
	@IBAction func handleLogout(_ target: UIBarButtonItem) {
		Utils.showConfirm(title: "Logout", msg: "Sicuro di voler uscire dall'app?", okBtnTxt: "Esci!", in: self) { confirmResultAction in
			switch confirmResultAction {
			case .success(true):
				self.LogOut()
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
