//
//  Search.swift
//  Localizabler
//
//  Created by Baluta Cristian on 09/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class Search {
	
	let kMinCharactersToSearch = 2
	var files: [String: LocalizationFile]?
	
	required init (files: [String: LocalizationFile]) {
		self.files = files
	}
	
	func searchInTerms (_ searchString: String) -> [Term] {
		
		let base = BaseLanguage(files: files!).get()
		var matchedTerms = [Term]()
		for term in base.terms {
			if term.lowercased().range(of: searchString.lowercased()) != nil ||
				searchString == "" ||
				searchString.count < kMinCharactersToSearch
			{
				matchedTerms.append( Term(value: term, newValue: nil, translationChanged: false) )
			}
		}
		return matchedTerms
	}
	
	func searchInTranslations (_ searchString: String) -> [Translation] {
		
		var matchedTranslations = [Translation]()
		
		guard (searchString != "" && searchString.count >= kMinCharactersToSearch) else {
			return matchedTranslations
		}
		let lowercaseSearchString = searchString.lowercased()
		
		for (lang, localizationFile) in files! {
			for line in localizationFile.allLines() {
				if line.translation != "" &&
                    line.translation.lowercased().range(of: lowercaseSearchString) != nil &&
                    line.comment == nil {
					
                    let data = Translation(value: line.translation, newValue: nil, languageCode: lang)
					matchedTranslations.append(data)
				}
			}
		}
		return matchedTranslations
	}
    
    func lineMatchingTranslation (translation: String) -> Line? {
        
        for (_, localizationFile) in files! {
            for line in localizationFile.allLines() {
                if line.translation == translation {
                    return line
                }
            }
        }
        return nil
    }
}
