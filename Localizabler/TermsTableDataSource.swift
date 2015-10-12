//
//  TermsTableDataSource.swift
//  Localizabler
//
//  Created by Baluta Cristian on 06/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class TermsTableDataSource: NSObject {
	
	var data = [TermData]()
	var onDidSelectRow: ((rowNumber: Int, key: TermData) -> Void)?
	
	init(tableView: NSTableView) {
		
		super.init()
		
		tableView.setDataSource(self)
		tableView.setDelegate(self)
	}
}

extension TermsTableDataSource: NSTableViewDataSource, NSTableViewDelegate {
	
	func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
		return data.count
	}
	
	func tableView(tableView: NSTableView,
		objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
			
			let theData: TermData = data[row]
			
			if (tableColumn?.identifier == "key") {
				return theData.value
			}
			else if (tableColumn?.identifier == "status") {
				return NSImage(named: theData.translationChanged
					? NSImageNameStatusPartiallyAvailable
					: NSImageNameStatusAvailable)
			}
			return nil
	}
	
	func tableViewSelectionDidChange(aNotification: NSNotification) {
		
		if let rowView: AnyObject = aNotification.object {
			if rowView.selectedRow >= 0 {
				onDidSelectRow?(rowNumber: rowView.selectedRow, key: self.data[rowView.selectedRow])
			}
		}
	}
	
	func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 20
	}
}
