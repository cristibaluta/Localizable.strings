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
	var data = [TranslationData]()
	var onEditTranslation: ((TranslationData) -> Void)?
	
	init(tableView: NSTableView) {
		
		super.init()
		
		tableView.setDataSource(self)
		tableView.setDelegate(self)
		
		// Translations table uses view based cells, they need to be loaded from nib and registered
		assert(NSNib(nibNamed: kTranslationCellIdentifier, bundle: NSBundle.mainBundle()) != nil, "err")
		
		if let nib = NSNib(nibNamed: kTranslationCellIdentifier, bundle: NSBundle.mainBundle()) {
			tableView.registerNib( nib, forIdentifier: kTranslationCellIdentifier)
		}
	}
}

extension TranslationsTableDataSource: NSTableViewDataSource, NSTableViewDelegate {
	
	func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
		return data.count
	}
	
	func tableViewSelectionDidChange(aNotification: NSNotification) {
		
		if let _: AnyObject = aNotification.object {
			
		}
	}
	
	func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 88
	}
	
	func tableView(tableView: NSTableView,
		viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
			
			let theData: TranslationData = data[row]
			let countryName = Countries.countryNameForCode(theData.countryCode)
			let cell = tableView.makeViewWithIdentifier(kTranslationCellIdentifier, owner: self) as? TranslationCell
			assert(cell != nil, "Cell can't be nil, check the identifier")
			
			cell?.flagImage!.image = NSImage(named: countryName)
			cell?.countryName?.stringValue = countryName
			cell?.textView?.stringValue = theData.value
			
			cell?.didEditCell = { [weak self] (cell: TranslationCell, newValue: String) in
				
				if let strongSelf = self {
					strongSelf.data[row].newValue = newValue
					strongSelf.onEditTranslation?(strongSelf.data[row])
				}
			}
			
			return cell
	}
}
