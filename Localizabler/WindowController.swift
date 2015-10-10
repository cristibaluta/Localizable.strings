//
//  WindowController.swift
//  Localizabler
//
//  Created by Baluta Cristian on 09/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
	
	var viewController: ViewController {
		get {
			return self.window!.contentViewController! as! ViewController
		}
	}
	var searchField: NSSearchField?
	
	override func windowDidLoad() {
		super.windowDidLoad()
	}
	
	@IBAction func browseButtonClicked(sender: NSButton) {
		viewController.browseButtonClicked(sender)
	}
}

extension WindowController: NSTextFieldDelegate {
	
	override func controlTextDidChange(obj: NSNotification) {
		RCLogO(obj.object?.stringValue)
	}
}
