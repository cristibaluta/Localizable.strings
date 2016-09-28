//
//  ViewController.swift
//  Localizabler
//
//  Created by Cristian Baluta on 01/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class AppViewController: NSViewController {
	
	@IBOutlet fileprivate var languagesPopup: NSPopUpButton?
	@IBOutlet var splitView: NSSplitView?
	@IBOutlet fileprivate var termsTableView: NSTableView?
	@IBOutlet fileprivate var translationsTableView: NSTableView?
	
	fileprivate var termsTableAlert: InlinedAlertView?
	fileprivate var translationsTableAlert: InlinedAlertView?
	fileprivate var termsTableDataSource: TermsTableDataSource?
	fileprivate var translationsTableDataSource: TranslationsTableDataSource?
	var url: URL?
	var files = [String: LocalizationFile]()
	fileprivate var allTerms = [TermData]()
	fileprivate var allTranslations = [TranslationData]()
	
	var contentDidChange: (() -> Void)?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		termsTableView?.backgroundColor = NSColor.clear
		
		termsTableDataSource = TermsTableDataSource(tableView: termsTableView!)
		translationsTableDataSource = TranslationsTableDataSource(tableView: translationsTableView!)
		
		termsTableDataSource?.onDidSelectRow = { [weak self] (rowNumber: Int, key: TermData) -> Void in
			
			guard let wself = self else {
				return
			}
			
			wself.allTranslations = [TranslationData]()
			
			for (lang, localizationFile) in wself.files {
                let data: TranslationData = (value: localizationFile.translationForTerm(key.value),
                                             newValue: nil,
                                             languageCode: lang)
				wself.allTranslations.append(data)
			}
			wself.translationsTableDataSource?.data = wself.allTranslations
			wself.translationsTableView?.reloadData()
			wself.updateAlerts("No selection")
		}
		termsTableDataSource?.termDidChange = { [weak self] (term: TermData) -> Void in
			
			guard let wself = self else {
				return
			}
			
			// A term was changed, update the value
			if let newValue = term.newValue {
				for file in wself.files.values {
					file.updateTerm(term.value, newValue: newValue)
				}
				wself.contentDidChange?()
			}
		}
		
		translationsTableDataSource?.translationDidChange = { [weak self] (translation: TranslationData) -> Void in
			
			guard let wself = self else {
				return
			}
			
			// A translation was changed, update the term object so it knows about the change
			if let selectedRow = wself.termsTableView?.selectedRow, selectedRow >= 0 {
				let termData = wself.termsTableDataSource?.data[selectedRow]
				wself.termsTableDataSource?.data[selectedRow].translationChanged = true
				
				// If there are changes in the translation
				if let newValue = translation.newValue {
					let file = wself.files[translation.languageCode]
					file?.updateTranslationForTerm(termData!.value, newValue: newValue)
				}
				
				wself.termsTableView?.reloadData(forRowIndexes: IndexSet(integer: wself.termsTableView!.selectedRow),
					columnIndexes: IndexSet(integer: 0))
				
				wself.contentDidChange?()
			}
		}
    }
    
    func scanDirectoryForLocalizationFiles() {
        
		_ = SearchIOSLocalizations().searchInDirectory(url!) { [weak self] (files: [String: URL]) -> Void in
			
			guard let wself = self else {
				return
			}
			
            RCLog(files)
			wself.languagesPopup?.removeAllItems()
			wself.files.removeAll()
			
            for (key, url) in files {
				wself.loadLocalizationFile(url, forKey: key)
                wself.languagesPopup?.addItem(withTitle: key)
            }
        }
	}
    
	func loadLocalizationFile (_ url: URL, forKey key: String) {
		do {
			files[key] = try IOSLocalizationFile(url: url)
		}
		catch LocalizationFileError.fileNotFound(url) {
			RCLog("Can't open file \(url)")
		} catch {
			RCLog("Unknown error")
		}
    }
	
	func showBaseLanguage() {
		
		let baseLanguage = BaseLanguage(files: files)
		let result = baseLanguage.get()
		languagesPopup?.selectItem(withTitle: result.language)
		showTerms(result.terms)
	}
	
	func showTerms (_ terms: [String]) {
		
		clear()
		
		allTerms = [TermData]()
		for term in terms {
			allTerms.append((value: term, newValue: nil, translationChanged: false) as TermData)
		}
		
		termsTableDataSource?.data = allTerms
		termsTableView?.reloadData()
		updateAlerts("No selection")
	}
	
	fileprivate func clear() {
		termsTableView?.deselectRow(termsTableView!.selectedRow)
		translationsTableDataSource?.data = []
		translationsTableView?.reloadData()
	}
	
	func markFilesAsSaved() {
		for i in 0..<self.termsTableDataSource!.data.count {
			termsTableDataSource?.data[i].translationChanged = false
		}
		termsTableView?.reloadData()
	}
	
	fileprivate func createNewTerm() {
		let term = "term \(arc4random())"
        let line: Line = (term: term, translation: "", isComment: false)
		for (_, localizationFile) in files {
			localizationFile.addLine(line)
		}
		// Insert it to the datasource
        let termData: TermData = (value: line.term, newValue: nil, translationChanged: false)
		termsTableDataSource?.data.append(termData)
		termsTableView?.beginUpdates()
		termsTableView?.insertRows(at: IndexSet(integer: termsTableDataSource!.data.count-1), withAnimation: .effectFade)
		termsTableView?.endUpdates()
	}
    
    fileprivate func removeTermAtIndex (row: Int) {
        let term: TermData = termsTableDataSource!.data[row]
        print(term)
        for (_, localizationFile) in files {
            localizationFile.removeTerm(term)
        }
        // Remove from the datasource
        termsTableView?.beginUpdates()
        termsTableView?.removeRows(at: IndexSet(integer: row), withAnimation: .effectFade)
        termsTableView?.endUpdates()
        termsTableDataSource?.data.remove(at: row)
        
        contentDidChange?()
    }
	
	
	// MARK: Actions
	
	@IBAction func languageDidChange (_ sender: NSPopUpButton) {
		
		let file = files[sender.titleOfSelectedItem!]
		showTerms(file!.allTerms())
	}
	
	@IBAction func addButtonClicked (_ sender: NSButton) {
		createNewTerm()
	}
	
	@IBAction func removeButtonClicked (_ sender: NSButton) {
        if let index = termsTableView?.selectedRow {
            removeTermAtIndex(row: index)
        }
	}
	
	func search (_ searchString: String) {
		
		termsTableView?.deselectRow(termsTableView!.selectedRow)
		
		let search = Search(files: files)
		//
		termsTableDataSource?.data = search.searchInTerms(searchString)
		termsTableView?.reloadData()
		//
		translationsTableDataSource?.data = search.searchInTranslations(searchString)
		translationsTableView?.reloadData()
		
		// Add Placeholders if no matches found
		updateAlerts("No matches")
	}
	
	
	// MARK: Alerts
	
	fileprivate func updateAlerts (_ message: String) {
		translationsAlert(message).isHidden = translationsTableDataSource?.data.count > 0
		termsAlert(message).isHidden = termsTableDataSource?.data.count > 0
	}
	
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
