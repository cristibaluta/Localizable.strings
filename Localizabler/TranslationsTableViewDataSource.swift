//
//  TranslationsTableViewDataSource.swift
//  Localizabler
//
//  Created by Baluta Cristian on 08/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class TranslationsTableViewDataSource: NSObject, NSTableViewDataSource, NSTableViewDelegate {

	let kTranslationCellIdentifier = "TranslationCell"
	var data = [TranslationData]()
//	var onEditTranslation: ((translation: TranslationData) -> Void)?
	var onEditTranslation: (() -> Void)?
	
	init(tableView: NSTableView) {
		
		super.init()
		
		tableView.setDataSource( self )
		tableView.setDelegate( self )
		
		assert(NSNib(nibNamed: kTranslationCellIdentifier, bundle: NSBundle.mainBundle()) != nil, "err")
		
		if let nib = NSNib(nibNamed: kTranslationCellIdentifier, bundle: NSBundle.mainBundle()) {
			tableView.registerNib( nib, forIdentifier: kTranslationCellIdentifier)
		}
	}
	
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
				RCLogO(newValue)
				if let strongSelf = self {
					strongSelf.data[row].newValue = newValue
					strongSelf.onEditTranslation?()
				}
			}
			
			return cell
	}
}
