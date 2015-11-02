//
//  Search.swift
//  Localizabler
//
//  Created by Baluta Cristian on 09/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class Search: NSObject {
	
	var files: [String: LocalizationFile]?
	
	required init(files: [String: LocalizationFile]) {
		super.init()
		self.files = files
	}
	
	func searchInTerms(searchString: String) -> [TermData] {
		
		var terms = [String]()
		if let file = files!["Base"] {
			terms = file.allTerms()
		} else if let file = files!["en"] {
			terms = file.allTerms()
		}
		
		var matchedTerms = [TermData]()
		for term in terms {
			if term.lowercaseString.rangeOfString(searchString.lowercaseString) != nil || searchString == "" {
				matchedTerms.append((value: term, newValue: nil, translationChanged: false) as TermData)
			}
		}
		return matchedTerms
	}
	
	func searchInTranslations(searchString: String) -> [TranslationData] {
		
		var matchedTranslations = [TranslationData]()
		
		guard searchString != "" else {
			return matchedTranslations
		}
		let lowercaseSearchString = searchString.lowercaseString
		
		for (lang, localizationFile) in files! {
			for line in localizationFile.allLines() {
				if line.translation != "" && line.translation.lowercaseString.rangeOfString(lowercaseSearchString) != nil {
					
					matchedTranslations.append(
						(value: line.translation,
						newValue: nil,
						languageCode: lang
						) as TranslationData
					)
				}
			}
		}
		return matchedTranslations
	}
}
