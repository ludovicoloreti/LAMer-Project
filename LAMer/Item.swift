//
//  Item.swift
//  LAMer
//
//  Created by Ludovico Loreti on 03/12/17.
//  Copyright © 2017 Ludovico Loreti. All rights reserved.
//

import Foundation
import UIKit

struct Item {
	let id: String
	let service: String
	let icon: String
	let username: String
	let password: String
	
	init(id: String, service: String, icon: String, username: String, password: String) {
		self.id = id
		self.service = service
		self.icon = icon
		self.username = username
		self.password = password
	}
}

