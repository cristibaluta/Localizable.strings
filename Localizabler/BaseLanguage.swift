//
//  BaseLanguage.swift
//  Localizabler
//
//  Created by Baluta Cristian on 31/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class BaseLanguage {

	var files = [String: LocalizationFile]()
	
	required convenience init (files: [String: LocalizationFile]) {
		self.init()
		self.files = files
	}
	
	func get() -> (language: String, terms: [String]) {
		
		if let file = files["Base"] {
			return (language: "Base", terms: file.allTerms())
		}
		else if let file = files["en"] {
			return (language: "en", terms: file.allTerms())
		}
		
		return (language: "", terms: [])
	}
}
