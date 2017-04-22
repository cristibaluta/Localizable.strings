//
//  RequestsTermsDataSource.swift
//  Localizable.strings
//
//  Created by Cristian Baluta on 22/04/2017.
//  Copyright © 2017 Cristian Baluta. All rights reserved.
//

import Cocoa

class RequestsTermsDataSource: NSObject {
    
    private var tableView: NSTableView!
    var data = [RequestTerm]()
    var highlightedRow = -1
    var onDidSelectRow: ((_ rowNumber: Int, _ key: RequestTerm) -> Void)?
    
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

extension RequestsTermsDataSource: NSTableViewDataSource {
    
    func numberOfRows (in aTableView: NSTableView) -> Int {
        return data.count
    }
    
    func tableView (_ tableView: NSTableView,
                    objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        let theData: RequestTerm = data[row]
        
        if (tableColumn?.identifier == "key") {
            return theData.key
        }
        else if (tableColumn?.identifier == "status") {
            return NSImage(named: true//theData.translationChanged || theData.newValue != nil
                ? NSImageNameStatusPartiallyAvailable
                : NSImageNameStatusAvailable)
        }
        return nil
    }
    
//    func tableView (_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
//        data[row].newValue = object as? String
//        termDidChange?(data[row])
//    }
    
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

extension RequestsTermsDataSource: NSTableViewDelegate {
    
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
