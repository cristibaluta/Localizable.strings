//
//  WindowController.swift
//  Localizabler
//
//  Created by Baluta Cristian on 09/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    @IBOutlet fileprivate var segmentedControl: NSSegmentedControl!
    @IBOutlet fileprivate var butOpen: NSButton!
    @IBOutlet fileprivate var searchField: NSSearchField!
    
    fileprivate var appWireframe: AppWireframe?
    var presenter: WindowPresenterInput?
    var localizationsPresenter: LocalizationsPresenterInput?
	
	override func windowDidLoad() {
		super.windowDidLoad()
		
		window?.titlebarAppearsTransparent = true
		window?.titleVisibility = NSWindowTitleVisibility.hidden
		setWindowTitle("Localizable.strings")
        segmentedControl.selectedSegment = 0
        
        let presenter = WindowPresenter()
        presenter.userInterface = self
        self.presenter = presenter
        
        appWireframe = AppWireframe(windowController: self)
        
		presenter.loadLastOpenedProject()
	}
}

extension WindowController {
    
    @IBAction func handleSegmentedControl (_ segmentedControl: NSSegmentedControl) {
        switch segmentedControl.selectedSegment {
        case 0:
            butOpen.isHidden = false
            break
        default:
            butOpen.isHidden = true
            break
        }
    }
    
	@IBAction func handleOpenButton (_ sender: NSButton) {
		presenter!.browseFiles()
	}
    
    @IBAction func handleSearch (_ sender: NSSearchField) {
        localizationsPresenter!.search(sender.stringValue)
    }
}

extension WindowController: WindowPresenterOutput {
    
    func setWindowTitle (_ title: String) {
        window?.title = title
    }
    
    func showNoProjectInterface() {
        
        let noProjectsController = appWireframe!.presentNoProjectsInterface()
        noProjectsController.onOpenButtonClicked = handleOpenButton
    }
    
    func showLocalizationsInterface (withFilesResult result: FilesResult) {
        
        let localizationsController = appWireframe!.presentLocalizationsInterface()
        localizationsController.windowPresenter = presenter
        localizationsPresenter = localizationsController.presenter
        // Load urls after the module is setup
//        localizationsController.presenter!.loadUrls(urls)
        localizationsPresenter!.openProjectWithFilesResult(result)
    }
}

extension WindowController: NSTextFieldDelegate {
	
	override func controlTextDidChange (_ obj: Notification) {
		
        guard let textField = obj.object as? NSTextField else {
            return
        }
		let searchString = textField.stringValue
		localizationsPresenter!.search(searchString)
	}
}
