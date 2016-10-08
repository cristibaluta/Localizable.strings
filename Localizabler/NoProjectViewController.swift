//
//  NoProjectViewController.swift
//  Localizabler
//
//  Created by Baluta Cristian on 31/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class NoProjectViewController: NSViewController {

	var onOpenButtonClicked: ((_ sender: NSButton) -> ())?
	
	class func instanceFromStoryboard() -> NoProjectViewController {
		let storyBoard = NSStoryboard(name: "Main", bundle: nil)
		return storyBoard.instantiateController(withIdentifier: "NoProjectViewController") as! NoProjectViewController
	}
	
	@IBAction func browseButtonClicked (_ sender: NSButton) {
		onOpenButtonClicked?(sender)
	}
}
