//
//  ViewController.swift
//  Localizabler
//
//  Created by Cristian Baluta on 01/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	@IBOutlet var segmentedControl: NSSegmentedControl?
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
			
            RCLog(localizationsDict)
			
			self.segmentedControl!.segmentCount = localizationsDict.count
            var i = 0
            for (key, url) in localizationsDict {
				self.loadLocalizationFile(url, forKey: key)
                self.segmentedControl?.setLabel(key, forSegment: i)
                i++
            }
        }
    }
    
	func loadLocalizationFile(url: NSURL, forKey key: String) {
        files[key] = IOSLocalizationFile(url: url)
    }
	
	func showBaseLanguage() {
		
		var keys = [String]()
		if let file = files["Base"] {
			keys = file.allTerms()
		}
		else if let file = files["en"] {
			keys = file.allTerms()
		}
		
		// Build TermData from Strings
		showKeys(keys)
	}
	
	func showKeys(keys: [String]) {
		
		var keysData = [TermData]()
		for key in keys {
			keysData.append((value: key, newValue: nil, translationChanged: false) as TermData)
		}
		
		termsTableDataSource?.data = keysData
		termsTableView?.reloadData()
	}
}
