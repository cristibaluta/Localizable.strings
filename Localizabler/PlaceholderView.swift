//
//  InlinedAlertView.swift
//  Localizabler
//
//  Created by Baluta Cristian on 07/11/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class PlaceholderView: NSView {
	
	@IBOutlet var textField: NSTextField?
	
	var message: String {
		get {
			return self.textField!.stringValue
		}
		set {
			self.textField!.stringValue = newValue
		}
	}
	
	class func instanceFromNib() -> PlaceholderView {
		
		var viewArray: NSArray? = []
		_ = Bundle.main.loadNibNamed(NSNib.Name(rawValue: "PlaceholderView"), owner: self, topLevelObjects: &viewArray)
		if let view = viewArray?[0] as? PlaceholderView {
			return view
		} else if let view = viewArray?[1] as? PlaceholderView {
			return view
		}
		return PlaceholderView()
	}
}
