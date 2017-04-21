//
//  ViewController.swift
//  Localizabler
//
//  Created by Cristian Baluta on 01/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class LocalizationsViewController: NSViewController {
    
    var presenter: LocalizationsPresenterInput?
    var windowPresenter: WindowPresenterInput?
    var wireframe: AppWireframe?
    
	@IBOutlet weak fileprivate var splitView: NSSplitView?
	@IBOutlet weak fileprivate var termsTableView: NSTableView?
    @IBOutlet weak fileprivate var translationsTableView: NSTableView?
    @IBOutlet weak fileprivate var filenamePopup: NSPopUpButton!
    @IBOutlet weak fileprivate var languagePopup: NSPopUpButton!
    @IBOutlet weak fileprivate var butSave: NSButton?
    @IBOutlet weak fileprivate var butAdd: NSButton?
    @IBOutlet weak fileprivate var butRemove: NSButton?
	
	fileprivate var termsTableAlert: PlaceholderView?
	fileprivate var translationsTableAlert: PlaceholderView?
    
    class func instanceFromStoryboard() -> LocalizationsViewController {
        let storyBoard = NSStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateController(withIdentifier: "LocalizationsViewController") as! LocalizationsViewController
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
        termsTableView!.backgroundColor = NSColor.clear
        butSave?.isEnabled = false
        presenter!.setupDataSourceFor(termsTableView: termsTableView!,
                                      translationsTableView: translationsTableView!)
        setFilenamesPopup([])
        setLanguagesPopup([])
    }
}

extension LocalizationsViewController {
    
	@IBAction func handleAddButtonClicked (_ sender: NSButton) {
        presenter!.insertNewTerm(afterIndex: termsTableView!.selectedRow)
	}
	
	@IBAction func handleRemoveButtonClicked (_ sender: NSButton) {
        
        let alert = NSAlert()
        alert.messageText = "Are you sure you want to remove this term?"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Delete")
        alert.addButton(withTitle: "Cancel")
        
        let result = alert.runModal()
        
        if result == NSAlertFirstButtonReturn {
            
        } else if ( result == NSAlertSecondButtonReturn ) {
            
        }
        
        if let index = termsTableView?.selectedRow {
            presenter!.removeTerm(atIndex: index)
        }
	}
    
    @IBAction func handleSaveButtonClicked (_ sender: NSButton) {
        presenter!.saveChanges()
    }
    
    @IBAction func handleFilePopupValueChange (_ sender: NSPopUpButton) {
//        searchField!.stringValue = ""
        presenter!.selectFileNamed(sender.titleOfSelectedItem!)
    }
    
    @IBAction func handleLanguagePopupValueChange (_ sender: NSPopUpButton) {
//        searchField!.stringValue = ""
        presenter!.selectLanguageNamed(sender.titleOfSelectedItem!)
    }
    
}

extension LocalizationsViewController {
	
	fileprivate func translationsAlert (_ message: String) -> PlaceholderView {
        
		if translationsTableAlert == nil {
			translationsTableAlert = PlaceholderView.instanceFromNib()
			translationsTableView?.addSubview(translationsTableAlert!)
			translationsTableAlert?.constrainToSuperview()
		}
		translationsTableAlert?.message = message
        
		return translationsTableAlert!
	}
	
	fileprivate func termsAlert (_ message: String) -> PlaceholderView {
        
		if termsTableAlert == nil {
			termsTableAlert = PlaceholderView.instanceFromNib()
			termsTableView?.addSubview(termsTableAlert!)
			termsTableAlert?.constrainToSuperview()
		}
		termsTableAlert?.message = message
        
		return termsTableAlert!
	}
}

extension LocalizationsViewController: LocalizationsPresenterOutput {
    
    func updatePlaceholders (message: String, hideTerms: Bool, hideTranslations: Bool) {
        
        translationsAlert(message).isHidden = hideTerms
        termsAlert(message).isHidden = hideTranslations
    }
    
    func enableSaving() {
        butSave?.isEnabled = true
    }
    
    func disableSaving() {
        butSave?.isEnabled = false
    }
    
    func insertNewTerm (atIndex index: Int) {
        
        termsTableView?.beginUpdates()
        termsTableView?.insertRows(at: IndexSet(integer: index), withAnimation: .effectFade)
        termsTableView?.endUpdates()
    }
    
    func removeTerm (atIndex index: Int) {
        
        termsTableView?.beginUpdates()
        termsTableView?.removeRows(at: IndexSet(integer: index), withAnimation: .effectFade)
        termsTableView?.endUpdates()
    }
    
    func reloadTerm (atIndex index: Int) {
        
        termsTableView?.reloadData(forRowIndexes: IndexSet(integer: index),
                                   columnIndexes: IndexSet(integer: 0))
    }
    
    func selectedTermRow() -> Int? {
        return termsTableView?.selectedRow
    }
    
    func selectTerm (atRow row: Int) {
        let lastIndex = IndexSet([row])
        self.termsTableView?.selectRowIndexes(lastIndex, byExtendingSelection: false)
    }
    
    func deselectActiveTerm() {
        termsTableView?.deselectRow(termsTableView!.selectedRow)
    }
    
    func enableTermsEditingOptions (enabled: Bool) {
        butAdd?.isHidden = !enabled
        butRemove?.isHidden = !enabled
    }
    
    ///MARK - Popups
    
    func setFilenamesPopup (_ filenames: [String]) {
        
        filenamePopup.removeAllItems()
        if filenames.count > 0 {
            filenamePopup.addItems(withTitles: filenames)
            filenamePopup.isEnabled = true
        }
    }
    
    func setLanguagesPopup (_ languages: [String]) {
        
        languagePopup.removeAllItems()
        if languages.count > 0 {
            languagePopup.addItems(withTitles: languages)
            languagePopup.isEnabled = true
        }
    }
    
    func selectFileNamed (_ filename: String) {
        filenamePopup.selectItem(withTitle: filename)
    }
    
    func selectLanguageNamed (_ language: String) {
        languagePopup.selectItem(withTitle: language)
    }
    
}
