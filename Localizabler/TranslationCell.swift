//
//  TranslationCell.swift
//  Localizabler
//
//  Created by Baluta Cristian on 10/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class TranslationCell: NSView {

	@IBOutlet var flagImage: NSImageView?
	@IBOutlet var countryName: NSTextField?
	@IBOutlet var textView: NSTextField?
	
	var didEditCell: ((cell: TranslationCell, newValue: String) -> Void)?
	
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
}

extension TranslationCell: NSTextFieldDelegate {
	
	override func controlTextDidBeginEditing(obj: NSNotification) {
		
	}
	
	override func controlTextDidChange(obj: NSNotification) {
		self.didEditCell?(cell: self, newValue: obj.object!.stringValue)
	}
	
	override func controlTextDidEndEditing(obj: NSNotification) {
		
	}
}
