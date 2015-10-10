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
	@IBOutlet var keysTableView: NSTableView?
	@IBOutlet var translationsTableView: NSTableView?
	
	var keysTableDataSource: KeysTableDataSource?
	var translationsTableDataSource: TranslationsTableDataSource?
	var languages = [String: LocalizationFile]()
	var url: NSURL?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		keysTableView?.backgroundColor = NSColor.clearColor()
		
		keysTableDataSource = KeysTableDataSource(tableView: keysTableView!)
		translationsTableDataSource = TranslationsTableDataSource(tableView: translationsTableView!)
		
		keysTableDataSource?.onRowPressed = { (rowNumber: Int, key: KeyData) -> Void in
			
			var translations = [TranslationData]()
			
			for (lang, localizationFile) in self.languages {
				
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
			self.keysTableDataSource?.data[self.keysTableView!.selectedRow].translationChanged = true
			RCLog(translation)
			RCLog(self.translationsTableDataSource?.data)
			
			self.keysTableView?.reloadDataForRowIndexes(NSIndexSet(index: self.keysTableView!.selectedRow),
				columnIndexes: NSIndexSet(index: 0))
		}
    }
    
    func scanDirectoryForLocalizationFiles() {
        
        _ = SearchIOSLocalizations().searchInDirectory(url!) { (localizationsDict) -> Void in
            RCLogO(localizationsDict)
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
        self.languages[key] = IOSLocalizationFile(url: url)
    }
	
	func showBaseLanguage() {
		
		var keys = [String]()
		if let file = languages["Base"] {
			keys = file.allTerms()
		}
		else if let file = languages["en"] {
			keys = file.allTerms()
		}
		
		// Build KeyData from Strings
		showKeys(keys)
	}
	
	func showKeys(keys: [String]) {
		
		var keysData = [KeyData]()
		for key in keys {
			keysData.append((value: key, newValue: nil, translationChanged: false) as KeyData)
		}
		
		keysTableDataSource?.data = keysData
		keysTableView?.reloadData()
	}
}
