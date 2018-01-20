//
//  TermsTableDataSource.swift
//  Localizabler
//
//  Created by Baluta Cristian on 06/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class TermsTableDataSource: NSObject {
	
    private var tableView: NSTableView!
	var data = [Term]()
    var highlightedRow = -1
	var onDidSelectRow: ((_ rowNumber: Int, _ key: Term) -> Void)?
	var termDidChange: ((Term) -> Void)?
	
	init (tableView: NSTableView) {
		super.init()
		
		tableView.dataSource = self
        tableView.delegate = self
        self.tableView = tableView
	}
    
    func reloadData() {
        tableView?.reloadData()
    }
}

extension TermsTableDataSource: NSTableViewDataSource {
	
	func numberOfRows (in aTableView: NSTableView) -> Int {
		return data.count
	}
	
	func tableView (_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        let theData: Term = data[row]
        
        if ((tableColumn?.identifier)?.rawValue == "key") {
            if theData.newValue != nil {
                return theData.newValue
            }
            return theData.value
        }
        else if ((tableColumn?.identifier)?.rawValue == "status") {
            return NSImage(named: theData.translationChanged || theData.newValue != nil
                ? NSImage.Name.statusPartiallyAvailable
                : NSImage.Name.statusAvailable)
        }
        return nil
	}
    
    func tableView (_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        data[row].newValue = object as? String
        termDidChange?(data[row])
    }
    
    @objc(tableView:willDisplayCell:forTableColumn:row:)
    func tableView(_ tableView: NSTableView, willDisplayCell cell: Any, for tableColumn: NSTableColumn?, row: Int) {

        if let textFieldCell = cell as? NSTextFieldCell {
            
            let selectedRowIndexes = tableView.selectedRowIndexes
            if selectedRowIndexes.contains(row) {
//                textFieldCell.textColor = NSColor.cyan
            } else {
                textFieldCell.textColor = highlightedRow == row ? NSColor.blue : NSColor.black
            }
////                textFieldCell.setFont(NSFont.boldSystemFont(ofSize: 12))
//            } else {
//                textFieldCell.textColor = NSColor.black
////                textFieldCell.setFont(NSFont.systemFont(ofSize: 12))
//            }
        }
    }
}

extension TermsTableDataSource: NSTableViewDelegate {
	
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
}
