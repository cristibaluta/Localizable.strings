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
	@IBOutlet var textField: TranslationTextField?
	
	var translationDidChange: ((_ cell: TranslationCell, _ newValue: String) -> Void)?
    var didSelect: ((_ cell: TranslationCell, _ value: String) -> Void)?
	
	override func mouseDown (with theEvent: NSEvent) {
		self.window?.makeFirstResponder(textField)
	}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField?.didBecomeFirstResponder = { [weak self] in
            if let strongSelf = self {
                strongSelf.didSelect?(strongSelf, strongSelf.textField!.stringValue)
            }
        }
    }
}

extension TranslationCell: NSTextFieldDelegate {
	
	override func controlTextDidBeginEditing (_ obj: Notification) {
		
	}
	
	override func controlTextDidChange (_ obj: Notification) {
        self.translationDidChange?(self, (obj.object! as AnyObject).stringValue)
	}
	
	override func controlTextDidEndEditing (_ obj: Notification) {
		
	}
}
