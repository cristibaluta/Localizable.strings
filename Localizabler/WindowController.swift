//
//  WindowController.swift
//  Localizabler
//
//  Created by Baluta Cristian on 09/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
	
	@IBOutlet fileprivate var searchField: NSSearchField?
    @IBOutlet fileprivate var filenamePopup: NSPopUpButton?
    @IBOutlet fileprivate var languagePopup: NSPopUpButton?
	@IBOutlet fileprivate var butOpen: NSButton?
    
    fileprivate var appWireframe: AppWireframe?
    var presenter: WindowPresenterInput?
    var localizationsPresenter: LocalizationsPresenterInput?
	
	override func windowDidLoad() {
		super.windowDidLoad()
		
		window?.titlebarAppearsTransparent = true
		window?.titleVisibility = NSWindowTitleVisibility.visible
		setWindowTitle("Localizable.strings")
        filenamePopup?.isEnabled = false
        languagePopup?.isEnabled = false
        setFilenamesPopup([])
        setLanguagesPopup([])
        
        let presenter = WindowPresenter()
        let interactor = WindowInteractor()
        presenter.userInterface = self
        presenter.interactor = interactor
        self.presenter = presenter
        
        appWireframe = AppWireframe(windowController: self)
        
		presenter.loadLastOpenedProject()
	}
}

extension WindowController {
	
	@IBAction func handleOpenButton (_ sender: NSButton) {
		presenter!.browseFiles()
	}
    
    @IBAction func handleFilePopupValueChange (_ sender: NSPopUpButton) {
        presenter!.selectFileNamed(sender.titleOfSelectedItem!)
    }
    
    @IBAction func handleLanguagePopupValueChange (_ sender: NSPopUpButton) {
        localizationsPresenter!.selectLanguageNamed(sender.titleOfSelectedItem!)
    }
}

extension WindowController: WindowPresenterOutput {
    
    func setWindowTitle (_ title: String) {
        window?.title = title
    }
    
    func setFilenamesPopup (_ filenames: [String]) {
        
        filenamePopup?.removeAllItems()
        if filenames.count > 0 {
            filenamePopup!.addItems(withTitles: filenames)
            filenamePopup!.isEnabled = true
        }
    }
    
    func setLanguagesPopup (_ languages: [String]) {
        
        languagePopup?.removeAllItems()
        if languages.count > 0 {
            languagePopup!.addItems(withTitles: languages)
            languagePopup!.isEnabled = true
        }
    }
    
    func selectLanguageNamed (_ language: String) {
        languagePopup!.selectItem(withTitle: language)
    }
    
    func showNoProjectInterface() {
        
        let noProjectsController = appWireframe!.presentNoProjectsInterface()
        noProjectsController.onOpenButtonClicked = handleOpenButton
    }
    
    func showLocalizationsInterface (withUrls urls: [String: URL]) {
        
        let localizationsController = appWireframe!.presentLocalizationsInterface()
        localizationsController.windowPresenter = presenter
        localizationsPresenter = localizationsController.presenter
        // Load urls after the module is setup
        localizationsController.presenter!.loadUrls(urls)
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
