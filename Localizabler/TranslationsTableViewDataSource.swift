//
//  TranslationsTableViewDataSource.swift
//  Localizabler
//
//  Created by Baluta Cristian on 08/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class TranslationsTableViewDataSource: NSObject, NSTableViewDataSource, NSTableViewDelegate {

	var data = [String]()
	
	func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
		
		return data.count
	}
	
	func tableView(tableView: NSTableView,
		objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
			
			if (tableColumn?.identifier == "translation") {
				return data[row]
			}
			return nil
	}
	
	func tableViewSelectionDidChange(aNotification: NSNotification) {
		
		if let rowView: AnyObject = aNotification.object {
			
		}
	}
	
	func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 50
	}
}
