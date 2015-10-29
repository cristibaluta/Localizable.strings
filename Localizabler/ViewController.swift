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
	@IBOutlet var termsTableView: NSTableView?
	@IBOutlet var translationsTableView: NSTableView?
	
	var termsTableDataSource: TermsTableDataSource?
	var translationsTableDataSource: TranslationsTableDataSource?
	var files = [String: LocalizationFile]()
	var url: NSURL?
	
	var onEditTranslation: ((TranslationData) -> Void)?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		termsTableView?.backgroundColor = NSColor.clearColor()
		
		termsTableDataSource = TermsTableDataSource(tableView: termsTableView!)
		translationsTableDataSource = TranslationsTableDataSource(tableView: translationsTableView!)
		
		termsTableDataSource?.onDidSelectRow = { [weak self] (rowNumber: Int, key: TermData) -> Void in
			
			guard let wself = self else {
				return
			}
			
			var translations = [TranslationData]()
			
			for (lang, localizationFile) in wself.files {
				
				translations.append(
					(value: localizationFile.translationForTerm(key.value),
					newValue: nil,
					countryCode: lang
					) as TranslationData
				)
			}
			wself.translationsTableDataSource?.data = translations
			wself.translationsTableView?.reloadData()
		}
		
		translationsTableDataSource?.onEditTranslation = { [weak self] (translation) -> Void in
			
			guard let wself = self else {
				return
			}
			
			// A translation was changed, change also the key object
			let termData = wself.termsTableDataSource?.data[wself.termsTableView!.selectedRow]
			wself.termsTableDataSource?.data[wself.termsTableView!.selectedRow].translationChanged = true
			
			// If there are changes in the translation
			if let newValue = translation.newValue {
				let file = wself.files[translation.countryCode]
				file?.updateTranslationForTerm(termData!.value, newValue: newValue)
			}
			
			wself.termsTableView?.reloadDataForRowIndexes(NSIndexSet(index: wself.termsTableView!.selectedRow),
				columnIndexes: NSIndexSet(index: 0))
			
			wself.onEditTranslation?(translation)
		}
    }
    
    func scanDirectoryForLocalizationFiles() {
        
        _ = SearchIOSLocalizations().searchInDirectory(url!) { [weak self] (localizationsDict) -> Void in
			
			guard let wself = self else {
				return
			}
			
            RCLogO(localizationsDict)
			wself.languagesPopup?.removeAllItems()
			
            for (key, url) in localizationsDict {
				wself.loadLocalizationFile(url, forKey: key)
                wself.languagesPopup?.addItemWithTitle(key)
            }
        }
	}
    
	func loadLocalizationFile(url: NSURL, forKey key: String) {
        files[key] = IOSLocalizationFile(url: url)
    }
	
	func showBaseLanguage() {
		
		var terms = [String]()
		if let file = files["Base"] {
			terms = file.allTerms()
			languagesPopup?.selectItemWithTitle("Base")
		}
		else if let file = files["en"] {
			terms = file.allTerms()
			languagesPopup?.selectItemWithTitle("en")
		}
		
		// Build TermData from Strings
		showTerms(terms)
	}
	
	func showTerms(terms: [String]) {
		
		clear()
		
		var termsData = [TermData]()
		for term in terms {
			termsData.append((value: term, newValue: nil, translationChanged: false) as TermData)
		}
		
		termsTableDataSource?.data = termsData
		termsTableView?.reloadData()
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
	
	
	// MARK: Actions
	
	@IBAction func languageDidChange(sender: NSPopUpButton) {
		
		let file = files[sender.titleOfSelectedItem!]
		showTerms(file!.allTerms())
	}
}
