//
//  WindowController.swift
//  Localizabler
//
//  Created by Baluta Cristian on 09/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
	
	var viewController: AppViewController {
		get {
			return self.window!.contentViewController! as! AppViewController
		}
	}
	var noProjectViewController: NoProjectViewController?
    
	@IBOutlet var searchField: NSSearchField?
    @IBOutlet var filePopup: NSPopUpButton?
    @IBOutlet var languagePopup: NSPopUpButton?
	@IBOutlet var butOpen: NSButton?
    private var appWireframe: AppWireframe?
	
	override func windowDidLoad() {
		super.windowDidLoad()
		
		window?.titlebarAppearsTransparent = true
		window?.titleVisibility = NSWindowTitleVisibility.visible;
		window?.title = "Localizabler"
        filePopup?.isEnabled = false
        
        appWireframe = AppWireframe()
		
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
        
		window?.title = url.absoluteString
        
		viewController.url = url
		viewController.scanDirectoryForLocalizationFiles()
		viewController.showBaseLanguage()
	}
	
	func showNoProjectVC() {
		noProjectViewController = NoProjectViewController.instanceFromStoryboard()
		noProjectViewController?.browseButtonClicked = { [weak self] in
			self?.browseFiles()
		}
		appWireframe!.presentNoProjectsController(noProjectViewController!, overController: viewController)
		viewController.splitView?.isHidden = true
	}
	
	func removeNoProjectVC() {
		appWireframe!.removeNoProjectsController(noProjectViewController)
		viewController.splitView?.isHidden = false
	}
}

extension WindowController {
	
	@IBAction func handleOpenButton (_ sender: NSButton) {
		browseFiles()
	}
    
    @IBAction func handleFilePopupValueChange (_ sender: NSPopUpButton) {
        viewController.selectFileNamed(sender.titleOfSelectedItem!)
    }
    
    @IBAction func handleLanguagePopupValueChange (_ sender: NSPopUpButton) {
//        viewController.selectFileNamed(sender.titleOfSelectedItem!)
    }
    
//	@IBAction func handleSaveButton (_ sender: NSButton) {
//		
//		if SaveChangesInteractor(files: viewController.selectedFiles).execute() {
//			viewController.markFilesAsSaved()
//			butSave?.isEnabled = false
//		}
//	}
	
	func browseFiles() {
		
		let panel = NSOpenPanel()
		panel.canChooseFiles = false
		panel.canChooseDirectories = true
		panel.allowsMultipleSelection = false
		panel.begin { [weak self] (result) -> Void in
			
			if result == NSFileHandlingPanelOKButton {
				if let url = panel.urls.first {
					self?.removeNoProjectVC()
					self?.window?.title = url.absoluteString
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
