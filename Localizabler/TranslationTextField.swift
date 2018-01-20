//
//  TranslationTextField.swift
//  Localizabler
//
//  Created by Cristian Baluta on 28/09/16.
//  Copyright © 2016 Cristian Baluta. All rights reserved.
//

import Cocoa

class TranslationTextField: NSTextField {
    
    var didBecomeFirstResponder: (() -> Void)?
    
    override func becomeFirstResponder() -> Bool {
        didBecomeFirstResponder?()
        return super.becomeFirstResponder()
    }
}
