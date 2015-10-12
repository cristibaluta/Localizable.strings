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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		termsTableView?.backgroundColor = NSColor.clearColor()
		
		termsTableDataSource = TermsTableDataSource(tableView: termsTableView!)
		translationsTableDataSource = TranslationsTableDataSource(tableView: translationsTableView!)
		
		termsTableDataSource?.onDidSelectRow = { (rowNumber: Int, key: TermData) -> Void in
			
			var translations = [TranslationData]()
			
			for (lang, localizationFile) in self.files {
				
				translations.append(
					(value: localizationFile.translationForTerm(key.value),
					newValue: nil,
					countryCode: lang
					) as TranslationData
				)
			}
			self.translationsTableDataSource?.data = translations
			self.translationsTableView?.reloadData()
		}
		
		translationsTableDataSource?.onEditTranslation = { (translation) -> Void in
			
			// A translation was changed, change also the key object
			let termData = self.termsTableDataSource?.data[self.termsTableView!.selectedRow]
			self.termsTableDataSource?.data[self.termsTableView!.selectedRow].translationChanged = true
			
			// If there are changes in the translation
			if let newValue = translation.newValue {
				let file = self.files[translation.countryCode]
				file?.updateTranslationForTerm(termData!.value, newValue: newValue)
			}
			
			self.termsTableView?.reloadDataForRowIndexes(NSIndexSet(index: self.termsTableView!.selectedRow),
				columnIndexes: NSIndexSet(index: 0))
		}
    }
    
    func scanDirectoryForLocalizationFiles() {
        
        _ = SearchIOSLocalizations().searchInDirectory(url!) { (localizationsDict) -> Void in
			
            RCLogO(localizationsDict)
			self.languagesPopup?.removeAllItems()
			
            for (key, url) in localizationsDict {
				self.loadLocalizationFile(url, forKey: key)
                self.languagesPopup?.addItemWithTitle(key)
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
	
	
	// MARK: Actions
	
	@IBAction func languageDidChange(sender: NSPopUpButton) {
		
		let file = files[sender.titleOfSelectedItem!]
		showTerms(file!.allTerms())
	}
}
