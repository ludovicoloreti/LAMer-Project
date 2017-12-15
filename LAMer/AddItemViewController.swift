//
//  AddItemViewController.swift
//  LAMer
//
//  Created by Ludovico Loreti on 03/12/17.
//  Copyright © 2017 Ludovico Loreti. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FBSDKLoginKit
import RNCryptor

class AddItemViewController: SecureViewController,  UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
	
	
	@IBOutlet weak var insideView: UIView!
	
	@IBOutlet weak var saveBtn: UIButton!
	@IBOutlet weak var passwd: UITextField!
	@IBOutlet weak var username: UITextField!
	@IBOutlet weak var pickerTextField: UITextField!
	
	let arrayList = ["", "Altervista.org", "Amazon.it", "Asos.com", "Facebook.com", "ForumCommunity.net", "ForumFree.it", "Google.it", "Instagram.com", "Linkedin.com", "Libero.it", "Ebay.com", "Microsoft.it", "Netflix.com", "Paypal.com", "Pinterest.com", "Satispay.it", "Sky.it", "Skype.com", "Snapchat.com", "Tim.it", "Tre.it", "Tumblr.com", "Twitter.com", "Vodafone.it", "Yahoo.it", "Wind.it"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		insideView.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
		if Auth.auth().currentUser?.uid == nil {
			self.dismiss(animated: false, completion: nil)
		}
		navigationController?.navigationBar.tintColor = UIColor.white;
		self.title = "Aggiungi Item"
		self.hideKeyboardWhenTappedAround()
		setSaveBtn(enabled: false)
		
		username.delegate = self
		passwd.delegate = self
		pickerTextField.delegate = self
		/*
		PICKER THINGS
		*/
		let picker = UIPickerView()
		picker.delegate = self
		picker.backgroundColor = primaryColor
		picker.tintColor = secondaryColor
		let toolBar = UIToolbar()
		toolBar.barStyle = UIBarStyle.blackOpaque
		toolBar.tintColor = secondaryColor
		toolBar.sizeToFit()
		
		let doneButton = UIBarButtonItem(title: "Fatto", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
		let spaceButtonOne = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		let newButton = UIBarButtonItem(title: "Nuovo", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
		let spaceButtonTwo = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		let cancelButton = UIBarButtonItem(title: "Annulla", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
		toolBar.setItems([cancelButton, spaceButtonOne, newButton, spaceButtonTwo, doneButton], animated: false)
		toolBar.isUserInteractionEnabled = true
		
		pickerTextField.inputView = picker
		pickerTextField.inputAccessoryView = toolBar
		
	}
	
	@objc func donePicker(sender: UIBarButtonItem)
	{
		//		print(sender.title!)
		if sender.title == "Fatto" {
			pickerTextField.resignFirstResponder()
		} else if sender.title == "Annulla" {
			pickerTextField.text = ""
			pickerTextField.resignFirstResponder()
		} else {
			print("Usa keyboard al posto del pickerview")
			pickerTextField.text = ""
			pickerTextField.inputView = nil
			pickerTextField.inputAccessoryView = nil
			pickerTextField.becomeFirstResponder()
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		// Resigns the target textField and assigns the next textField in the form.
		
		switch textField {
		case pickerTextField:
			pickerTextField.resignFirstResponder()
			username.becomeFirstResponder()
			break
		case username:
			username.resignFirstResponder()
			passwd.becomeFirstResponder()
			break
		case passwd:
			passwd.resignFirstResponder()
			setSaveBtn(enabled: true)
			self.view.endEditing(true)
			break
		default:
			break
		}
		return true
	}
	
	func setSaveBtn(enabled:Bool) {
		if enabled {
			saveBtn.alpha = 1.0
			saveBtn.isEnabled = true
		} else {
			saveBtn.alpha = 0.5
			saveBtn.isEnabled = false
		}
	}
	
	
	@IBAction func saveItem(_ sender: Any) {
		print("saving account")
		let sv = UIViewController.displaySpinner(onView: self.view)
		
		self.setSaveBtn(enabled: false)
		self.saveBtn.setTitle("", for: .normal)
		
		guard let service = pickerTextField.text else { return }
		guard let usrnm = username.text else { return }
		guard let pass = passwd.text else { return }
		let formFilled = usrnm != "" && username != nil && pickerTextField != nil && service != "" && pass != "" && passwd != nil
		if formFilled != true {
			Utils.showAlert(title: "Errore", msg: "Compila tutti i campi!", in: self)
			return
		}
		let icon = "https://icons.better-idea.org/icon?url=\(service.lowercased())&size=16..50..100&fallback_icon_color=E6AF00"
		// &fallback_icon_url=https://reactjs.org/favicon.ico
		
		// inserisco nel database sotto la collection ITEMS capitanato dall'UID dell'user
		// l'username dell'utente
		guard let uid = Auth.auth().currentUser?.uid else { return } // attenzione ai lameronzoli
		let dbQuery = dbRef.child("items").child(uid).child("data").childByAutoId()
		let encryptedPass = try! Utils.encryptMessage(message: pass, encryptionKey: dbQuery.key)
		let dbData = ["id": dbQuery.key,"service": service, "username": usrnm, "password": encryptedPass, "icon": icon]
		dbQuery.updateChildValues(dbData, withCompletionBlock: {
			(err, ref) in
			if err == nil {
				print("\n Aggiunto al dataabse!!! \(ref)")
			} else {
				UIViewController.removeSpinner(spinner: sv)
				print("\n Errore nell'aggiungere data al db!\n info: \(err!.localizedDescription)")
				return
			}
			self.dismiss(animated: false, completion: {
				UIViewController.removeSpinner(spinner: sv)
				//				print("torno in homepage")
			})
		})
		// torna in homepage!
		return
		
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		var pickerLabel: UILabel? = (view as? UILabel)
		if pickerLabel == nil {
			pickerLabel = UILabel()
			pickerLabel?.textAlignment = .center
		}
		pickerLabel?.font = UIFont(name: "AvenirNext-Medium", size: 18)
		pickerLabel?.text = arrayList[row]
		pickerLabel?.textColor = secondaryColor
		return pickerLabel!
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return arrayList.count
	}
	
	// This function sets the text of the picker view to the content of the "arrayList" array
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		pickerTextField.textColor = secondaryColor
		return arrayList[row]
	}
	
	// When user selects an option, this function will set the text of the text field to reflect
	// the selected option.
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		pickerTextField.text = arrayList[row]
	}
}


