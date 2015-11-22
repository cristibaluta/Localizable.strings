//
//  ViewController.swift
//  Localizabler
//
//  Created by Cristian Baluta on 01/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	
	@IBOutlet var languagesPopup: NSPopUpButton?
	@IBOutlet var splitView: NSSplitView?
	@IBOutlet var termsTableView: NSTableView?
	@IBOutlet var translationsTableView: NSTableView?
	
	var termsTableAlert: InlinedAlertView?
	var translationsTableAlert: InlinedAlertView?
	var termsTableDataSource: TermsTableDataSource?
	var translationsTableDataSource: TranslationsTableDataSource?
	var url: NSURL?
	var files = [String: LocalizationFile]()
	var allTerms = [TermData]()
	var allTranslations = [TranslationData]()
	
	var contentDidChange: (() -> Void)?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		termsTableView?.backgroundColor = NSColor.clearColor()
		
		termsTableDataSource = TermsTableDataSource(tableView: termsTableView!)
		translationsTableDataSource = TranslationsTableDataSource(tableView: translationsTableView!)
		
		termsTableDataSource?.onDidSelectRow = { [weak self] (rowNumber: Int, key: TermData) -> Void in
			
			guard let wself = self else {
				return
			}
			
			wself.allTranslations = [TranslationData]()
			
			for (lang, localizationFile) in wself.files {
				wself.allTranslations.append(
					(value: localizationFile.translationForTerm(key.value),
					newValue: nil,
					languageCode: lang
					) as TranslationData
				)
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
			if let selectedRow = wself.termsTableView?.selectedRow where selectedRow >= 0 {
				let termData = wself.termsTableDataSource?.data[selectedRow]
				wself.termsTableDataSource?.data[selectedRow].translationChanged = true
				
				// If there are changes in the translation
				if let newValue = translation.newValue {
					let file = wself.files[translation.languageCode]
					file?.updateTranslationForTerm(termData!.value, newValue: newValue)
				}
				
				wself.termsTableView?.reloadDataForRowIndexes(NSIndexSet(index: wself.termsTableView!.selectedRow),
					columnIndexes: NSIndexSet(index: 0))
				
				wself.contentDidChange?()
			}
		}
    }
    
    func scanDirectoryForLocalizationFiles() {
        
		_ = SearchIOSLocalizations().searchInDirectory(url!) { [weak self] (files: [String: NSURL]) -> Void in
			
			guard let wself = self else {
				return
			}
			
            RCLogO(files)
			wself.languagesPopup?.removeAllItems()
			wself.files.removeAll()
			
            for (key, url) in files {
				wself.loadLocalizationFile(url, forKey: key)
                wself.languagesPopup?.addItemWithTitle(key)
            }
        }
	}
    
	func loadLocalizationFile (url: NSURL, forKey key: String) {
		do {
			files[key] = try IOSLocalizationFile(url: url)
		}
		catch LocalizationFileError.FileNotFound(url) {
			RCLog("Can't open file \(url)")
		} catch {
			RCLog("Unknown error")
		}
    }
	
	func showBaseLanguage() {
		
		let baseLanguage = BaseLanguage(files: files)
		let result = baseLanguage.get()
		languagesPopup?.selectItemWithTitle(result.language)
		showTerms(result.terms)
	}
	
	func showTerms (terms: [String]) {
		
		clear()
		
		allTerms = [TermData]()
		for term in terms {
			allTerms.append((value: term, newValue: nil, translationChanged: false) as TermData)
		}
		
		termsTableDataSource?.data = allTerms
		termsTableView?.reloadData()
		updateAlerts("No selection")
	}
	
	func clear() {
		termsTableView?.deselectRow(termsTableView!.selectedRow)
		translationsTableDataSource?.data = []
		translationsTableView?.reloadData()
	}
	
	func markFilesAsSaved() {
		for i in 0...self.termsTableDataSource!.data.count-1 {
			termsTableDataSource?.data[i].translationChanged = false
		}
		termsTableView?.reloadData()
	}
	
	func createNewLine() {
		let term = "term \(random())"
		let line = (term: term, translation: "", isComment: false)
		for (_, localizationFile) in files {
			localizationFile.addLine(line)
		}
		// Insert it to the datasource
		termsTableDataSource?.data.append((value: line.term, newValue: nil, translationChanged: false))
		termsTableView?.beginUpdates()
		termsTableView?.insertRowsAtIndexes(NSIndexSet(index: termsTableDataSource!.data.count-1), withAnimation: NSTableViewAnimationOptions.EffectFade)
		termsTableView?.endUpdates()
	}
	
	
	// MARK: Actions
	
	@IBAction func languageDidChange (sender: NSPopUpButton) {
		
		let file = files[sender.titleOfSelectedItem!]
		showTerms(file!.allTerms())
	}
	
	@IBAction func addButtonClicked (sender: NSButton) {
		createNewLine()
	}
	
	@IBAction func removeButtonClicked (sender: NSButton) {
		
	}
	
	func search (searchString: String) {
		
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
	
	private func updateAlerts (message: String) {
		translationsAlert(message).hidden = translationsTableDataSource?.data.count > 0
		termsAlert(message).hidden = termsTableDataSource?.data.count > 0
	}
	
	private func translationsAlert (message: String) -> InlinedAlertView {
		if translationsTableAlert == nil {
			translationsTableAlert = InlinedAlertView.instanceFromNib()
			translationsTableView?.addSubview(translationsTableAlert!)
			translationsTableAlert?.constrainToSuperview()
		}
		translationsTableAlert?.message = message
		return translationsTableAlert!
	}
	
	private func termsAlert (message: String) -> InlinedAlertView {
		if termsTableAlert == nil {
			termsTableAlert = InlinedAlertView.instanceFromNib()
			termsTableView?.addSubview(termsTableAlert!)
			termsTableAlert?.constrainToSuperview()
		}
		termsTableAlert?.message = message
		return termsTableAlert!
	}
}
