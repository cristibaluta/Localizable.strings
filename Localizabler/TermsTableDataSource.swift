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
	var onDidSelectRow: ((_ rowNumber: Int, _ key: TermData) -> Void)?
	var termDidChange: ((TermData) -> Void)?
	
	init (tableView: NSTableView) {
		super.init()
		
		tableView.dataSource = self
		tableView.delegate = self
	}
}

extension TermsTableDataSource: NSTableViewDataSource, NSTableViewDelegate {
	
	func numberOfRows (in aTableView: NSTableView) -> Int {
		return data.count
	}
	
	func tableView (_ tableView: NSTableView,
		objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
			
			let theData: TermData = data[row]
			
			if (tableColumn?.identifier == "key") {
				if theData.newValue != nil {
					return theData.newValue
				}
				return theData.value
			}
			else if (tableColumn?.identifier == "status") {
				return NSImage(named: theData.translationChanged || theData.newValue != nil
					? NSImageNameStatusPartiallyAvailable
					: NSImageNameStatusAvailable)
			}
			return nil
	}
	
	func tableViewSelectionDidChange (_ aNotification: Notification) {
		
		if let rowView: AnyObject = aNotification.object as AnyObject? {
			if rowView.selectedRow >= 0 {
				onDidSelectRow?(rowView.selectedRow, self.data[rowView.selectedRow])
			}
		}
	}
	
	func tableView (_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 20
	}
	
	func tableView (_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
		data[row].newValue = object as? String
		termDidChange?(data[row])
	}
}
