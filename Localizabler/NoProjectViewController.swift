//
//  NoProjectViewController.swift
//  Localizabler
//
//  Created by Baluta Cristian on 31/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class NoProjectViewController: NSViewController {

	var browseButtonClicked: (() -> ())?
	
	class func instanceFromStoryboard() -> NoProjectViewController {
		let storyBoard = NSStoryboard(name: "Main", bundle: nil)
		return storyBoard.instantiateControllerWithIdentifier("NoProjectViewController") as! NoProjectViewController
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	@IBAction func browseButtonClicked(sender: NSButton) {
		browseButtonClicked?()
	}
}
