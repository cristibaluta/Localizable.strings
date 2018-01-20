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
		window?.titleVisibility = NSWindow.TitleVisibility.hidden
		setWindowTitle("Localizable.strings")
        segmentedControl.selectedSegment = 0
        
        let presenter = WindowPresenter()
        presenter.userInterface = self
        self.presenter = presenter
        
        appWireframe = AppWireframe(windowController: self)
        presenter.appWireframe = appWireframe
        
		presenter.loadLastOpenedProject()
	}
}

extension WindowController {
    
    @IBAction func handleSegmentedControl (_ segmentedControl: NSSegmentedControl) {
        presenter!.selectScreen(segmentedControl.selectedSegment)
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
