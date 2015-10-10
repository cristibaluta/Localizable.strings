//
//  Terms.swift
//  Localizabler
//
//  Created by Cristian Baluta on 02/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

protocol LocalizationFile {
	
	var url: NSURL? {get}
	/// Whenever a translation changes a hasChanges flag is set
	var hasChanges: Bool {get}
	
	init(url: NSURL)
	init(content: String)
	
	/// Returns all lines found in the file in their order, comments and blank lines including
	func allLines() -> [Line]
	
	/// Returns all the terms found in the file in their order
    func allTerms() -> [String]
	
	/// Returns the translation for the specified term
    func translationForTerm(term: String) -> String
	
	/// Updates the translation for the specified term. You need to call  save for saving to the original file
    func updateTranslationForTerm(term: String, newValue: String)
	
	/// This will convert dictionaries back to string and save to the original file
	func content() -> String
}
