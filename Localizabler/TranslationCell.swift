//
//  TranslationCell.swift
//  Localizabler
//
//  Created by Baluta Cristian on 10/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class TranslationCell: NSTableRowView {

	@IBOutlet var flagImage: NSImageView?
	@IBOutlet var countryName: NSTextField?
	@IBOutlet var textView: NSTextField?
	
	var translationDidChangeInCell: ((_ cell: TranslationCell, _ newValue: String) -> Void)?
	
	override func mouseDown (with theEvent: NSEvent) {
		self.window?.makeFirstResponder(textView)
	}
}

extension TranslationCell: NSTextFieldDelegate {
	
	override func controlTextDidBeginEditing (_ obj: Notification) {
		
	}
	
	override func controlTextDidChange (_ obj: Notification) {
		self.translationDidChangeInCell?(self, (obj.object! as AnyObject).stringValue)
	}
	
	override func controlTextDidEndEditing (_ obj: Notification) {
		
	}
}
