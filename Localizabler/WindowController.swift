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
	var noProjectViewController: NoProjectViewController?
	@IBOutlet var searchField: NSSearchField?
	@IBOutlet var pathControl: NSPathControl?
	@IBOutlet var butBrowse: NSButton?
	@IBOutlet var butSave: NSButton?
	
	override func windowDidLoad() {
		super.windowDidLoad()
		
		window?.titlebarAppearsTransparent = true
		window?.titleVisibility = NSWindowTitleVisibility.Hidden;
		window?.title = "Localizabler"
		butSave?.enabled = false
		
		loadLastOpenedProject()
	}
	
	func loadLastOpenedProject() {
//		History().setLastProjectDir(nil)
		if let dir = History().getLastProjectDir() {
			if let url = NSURL(string: dir) {
				loadProjectAtUrl(url)
			}
		} else {
			showNoProjectVC()
		}
	}
	
	func loadProjectAtUrl(url: NSURL) {
		pathControl?.URL = url
		viewController.url = url
		viewController.scanDirectoryForLocalizationFiles()
		viewController.showBaseLanguage()
		viewController.contentDidChange = { [weak self] in
			self?.butSave?.enabled = true
		}
	}
	
	func showNoProjectVC() {
		noProjectViewController = NoProjectViewController.instanceFromStoryboard()
		noProjectViewController?.browseButtonClicked = { [weak self] in
			self?.browseFiles()
		}
		Wireframe.presentNoProjectsController(noProjectViewController!, overController: viewController)
		viewController.splitView?.hidden = true
	}
	
	func removeNoProjectVC() {
		Wireframe.removeNoProjectsController(noProjectViewController)
		viewController.splitView?.hidden = false
	}
	
	
	// MARK: Actions
	
	@IBAction func browseButtonClicked(sender: NSButton) {
		browseFiles()
	}
	
	@IBAction func saveButtonClicked(sender: NSButton) {
		
		if Save(files: viewController.files).execute() {
			viewController.markFilesAsSaved()
			butSave?.enabled = false
		}
	}
	
	func browseFiles() {
		
		let panel = NSOpenPanel()
		panel.canChooseFiles = false
		panel.canChooseDirectories = true
		panel.allowsMultipleSelection = false;
		panel.beginWithCompletionHandler { [weak self] (result) -> Void in
			
			if result == NSFileHandlingPanelOKButton {
				if let url = panel.URLs.first {
					self?.removeNoProjectVC()
					self?.pathControl!.URL = url
					self?.loadProjectAtUrl(url)
					History().setLastProjectDir(url.absoluteString)
				}
			}
		}
	}
}

extension WindowController: NSTextFieldDelegate {
	
	override func controlTextDidChange(obj: NSNotification) {
		
		guard let searchString = obj.object?.stringValue else {
			return
		}
		viewController.search(searchString)
	}
}
