//
//  Item.swift
//  LAMer
//
//  Created by Ludovico Loreti on 03/12/17.
//  Copyright © 2017 Ludovico Loreti. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase

class ItemCell: UITableViewCell {
	
	@IBOutlet weak var serviceLabel: UILabel!
	@IBOutlet weak var imgView: UIImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
