//
//  TranslationsTableDataSource.swift
//  Localizabler
//
//  Created by Baluta Cristian on 08/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class TranslationsTableDataSource: NSObject {
	
	let kTranslationCellIdentifier = "TranslationCell"
	let kCellHeight = CGFloat(88)
	var data = [TranslationData]()
	var translationDidChange: ((TranslationData) -> Void)?
	
	init (tableView: NSTableView) {
		super.init()
		
		tableView.dataSource = self
		tableView.delegate = self
		
		// Translations table uses view based cells, they need to be loaded from nib and registered
		assert(NSNib(nibNamed: kTranslationCellIdentifier, bundle: Bundle.main) != nil, "err")
		
		if let nib = NSNib(nibNamed: kTranslationCellIdentifier, bundle: Bundle.main) {
			tableView.register( nib, forIdentifier: kTranslationCellIdentifier)
		}
	}
}

extension TranslationsTableDataSource: NSTableViewDataSource, NSTableViewDelegate {
	
	func numberOfRows (in aTableView: NSTableView) -> Int {
		return data.count
	}
	
	func tableViewSelectionDidChange (_ aNotification: Notification) {
		
		if let _: AnyObject = aNotification.object as AnyObject? {
			
		}
	}
	
	func tableView (_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return kCellHeight
	}
	
	func tableView (_ tableView: NSTableView,
		viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
			
			let translationData: TranslationData = data[row]
			let countryName = CountryName.countryNameForLanguageCode(translationData.languageCode)
			let cell = tableView.make(withIdentifier: kTranslationCellIdentifier, owner: self) as? TranslationCell
			assert(cell != nil, "Cell can't be nil, check the identifier")
			
			cell?.flagImage!.image = NSImage(named: countryName)
			cell?.countryName?.stringValue = "\(translationData.languageCode)\n\(countryName)"
			cell?.textView?.stringValue = translationData.value
			
			cell?.translationDidChangeInCell = { [weak self] (cell: TranslationCell, newValue: String) in
				
				if let strongSelf = self {
					strongSelf.data[row].newValue = newValue
					strongSelf.translationDidChange?(strongSelf.data[row])
				}
			}
			
			return cell
	}
}
