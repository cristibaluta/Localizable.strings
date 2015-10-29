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
	@IBOutlet var searchField: NSSearchField?
	@IBOutlet var pathControl: NSPathControl?
	@IBOutlet var butBrowse: NSButton?
	@IBOutlet var butSave: NSButton?
	
	override func windowDidLoad() {
		super.windowDidLoad()
		
		window?.titlebarAppearsTransparent = true
		window?.titleVisibility = NSWindowTitleVisibility.Hidden;
		butSave?.enabled = false
		
		loadLastOpenedProject()
	}
	
	func loadLastOpenedProject() {
		if let dir = NSUserDefaults.standardUserDefaults().objectForKey("localizationsDirectory") {
			if let url = NSURL(string: dir as! String) {
				self.loadProjectAtUrl(url)
			}
		}
	}
	
	func loadProjectAtUrl(url: NSURL) {
		pathControl?.URL = url
		viewController.url = url
		viewController.scanDirectoryForLocalizationFiles()
		viewController.showBaseLanguage()
		viewController.onEditTranslation = { [weak self] (translationData) -> Void in
			self?.butSave?.enabled = true
		}
	}
	
	
	// MARK: Actions
	
	@IBAction func browseButtonClicked(sender: NSButton) {
		
		let panel = NSOpenPanel()
		panel.canChooseFiles = false
		panel.canChooseDirectories = true
		panel.allowsMultipleSelection = false;
		panel.beginWithCompletionHandler { (result) -> Void in
			
			if result == NSFileHandlingPanelOKButton {
				self.pathControl!.URL = panel.URLs.first
				NSUserDefaults.standardUserDefaults().setObject(panel.URLs.first?.absoluteString, forKey: "localizationsDirectory")
				NSUserDefaults.standardUserDefaults().synchronize()
				self.loadProjectAtUrl(panel.URLs.first!)
			}
		}
	}
	
	@IBAction func saveButtonClicked(sender: NSButton) {
		
		if Save(files: viewController.files).execute() {
			viewController.markFilesAsSaved()
			butSave?.enabled = false
		}
	}
}

extension WindowController: NSTextFieldDelegate {
	
	override func controlTextDidChange(obj: NSNotification) {
		RCLogO(obj.object?.stringValue)
	}
}
