//
//  Search.swift
//  Localizabler
//
//  Created by Baluta Cristian on 09/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class Search: NSObject {
	
	let kMinCharactersToSearch = 2
	var files: [String: LocalizationFile]?
	
	required init (files: [String: LocalizationFile]) {
		super.init()
		self.files = files
	}
	
	func searchInTerms (searchString: String) -> [TermData] {
		
		let base = BaseLanguage(files: files!).get()
		var matchedTerms = [TermData]()
		for term in base.terms {
			if term.lowercaseString.rangeOfString(searchString.lowercaseString) != nil ||
				searchString == "" ||
				searchString.characters.count < kMinCharactersToSearch
			{
				matchedTerms.append((value: term, newValue: nil, translationChanged: false) as TermData)
			}
		}
		return matchedTerms
	}
	
	func searchInTranslations (searchString: String) -> [TranslationData] {
		
		var matchedTranslations = [TranslationData]()
		
		guard (searchString != "" && searchString.characters.count >= kMinCharactersToSearch) else {
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
