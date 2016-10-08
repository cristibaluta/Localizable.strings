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
    @IBOutlet weak fileprivate var butSave: NSButton?
	
	fileprivate var termsTableAlert: InlinedAlertView?
	fileprivate var translationsTableAlert: InlinedAlertView?
    
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
}

extension LocalizationsViewController {
	
	fileprivate func translationsAlert (_ message: String) -> InlinedAlertView {
        
		if translationsTableAlert == nil {
			translationsTableAlert = InlinedAlertView.instanceFromNib()
			translationsTableView?.addSubview(translationsTableAlert!)
			translationsTableAlert?.constrainToSuperview()
		}
		translationsTableAlert?.message = message
        
		return translationsTableAlert!
	}
	
	fileprivate func termsAlert (_ message: String) -> InlinedAlertView {
        
		if termsTableAlert == nil {
			termsTableAlert = InlinedAlertView.instanceFromNib()
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
    
    func showNoProjectInterface() {
        
    }
    
    func enableSaving() {
        butSave?.isEnabled = true
    }
    
    func deselectTerm() {
        termsTableView?.deselectRow(termsTableView!.selectedRow)
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
    
    func selectedRow() -> Int? {
        return termsTableView?.selectedRow
    }
    
    func showLanguagesPopup (_ languages: [String]) {
        windowPresenter!.setLanguagesPopup(languages)
    }
    
    func selectLanguage (_ language: String) {
        windowPresenter!.selectLanguageNamed(language)
    }
}
