//
//  FacebookCustomButton.swift
//  LAMer
//
//  Created by Ludovico Loreti on 30/11/17.
//  Copyright © 2017 Ludovico Loreti. All rights reserved.

import Foundation
import UIKit


class FacebookCustomButton:UIButton {
	
	var highlightedColor =  UIColor(red: 139/255, green: 157/255, blue: 95/255, alpha: 1)
	var fbColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
	{
		didSet {
			if isHighlighted {
				backgroundColor = highlightedColor
			} else {
				backgroundColor = fbColor
			}
		}
	}
	
	override var isHighlighted: Bool {
		didSet {
			if isHighlighted {
				backgroundColor = highlightedColor
			} else {
				backgroundColor = fbColor
			}
		}
	}
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setup()
	}
	
	func setup() {
		self.layer.borderColor = UIColor.white.cgColor
		self.layer.borderWidth = 2.0
		self.layer.cornerRadius = self.frame.height / 2
		self.clipsToBounds = true
	}
}

