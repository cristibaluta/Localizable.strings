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
		window?.titleVisibility = NSWindowTitleVisibility.hidden;
		window?.title = "Localizabler"
		butSave?.isEnabled = false
		
		loadLastOpenedProject()
	}
	
	func loadLastOpenedProject() {
		History().setLastProjectDir(nil)
		if let dir = History().getLastProjectDir() {
			if let url = URL(string: dir) {
				loadProjectAtUrl(url)
			}
		} else {
			showNoProjectVC()
		}
	}
	
	func loadProjectAtUrl (_ url: URL) {
		pathControl?.url = url
		viewController.url = url
		viewController.scanDirectoryForLocalizationFiles()
		viewController.showBaseLanguage()
		viewController.contentDidChange = { [weak self] in
			self?.butSave?.isEnabled = true
		}
	}
	
	func showNoProjectVC() {
		noProjectViewController = NoProjectViewController.instanceFromStoryboard()
		noProjectViewController?.browseButtonClicked = { [weak self] in
			self?.browseFiles()
		}
		Wireframe.presentNoProjectsController(noProjectViewController!, overController: viewController)
		viewController.splitView?.isHidden = true
	}
	
	func removeNoProjectVC() {
		Wireframe.removeNoProjectsController(noProjectViewController)
		viewController.splitView?.isHidden = false
	}
	
	
	// MARK: Actions
	
	@IBAction func browseButtonClicked (_ sender: NSButton) {
		browseFiles()
	}
	
	@IBAction func saveButtonClicked (_ sender: NSButton) {
		
		if SaveChangesInteractor(files: viewController.files).execute() {
			viewController.markFilesAsSaved()
			butSave?.isEnabled = false
		}
	}
	
	func browseFiles() {
		
		let panel = NSOpenPanel()
		panel.canChooseFiles = false
		panel.canChooseDirectories = true
		panel.allowsMultipleSelection = false
		panel.begin { [weak self] (result) -> Void in
			
			if result == NSFileHandlingPanelOKButton {
				if let url = panel.urls.first {
					self?.removeNoProjectVC()
					self?.pathControl!.url = url
					self?.loadProjectAtUrl(url)
					History().setLastProjectDir(url.absoluteString)
				}
			}
		}
	}
}

extension WindowController: NSTextFieldDelegate {
	
	override func controlTextDidChange (_ obj: Notification) {
		
        guard let textField = obj.object as? NSTextField else {
            return
        }
		let searchString = textField.stringValue
		viewController.search(searchString)
	}
}
