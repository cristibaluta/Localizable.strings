//
//  Countries.swift
//  Localizabler
//
//  Created by Baluta Cristian on 10/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class CountryName {
	
    class func fromLanguageCode (_ languageCode: String) -> (languageName: String, countryName: String) {
		
		// init an english NSLocale to get the english name of all NSLocale-Objects
		let englishLocale = Locale.init(identifier :  "en_US")
		
        let englishLanguageName = (englishLocale as NSLocale).displayName(forKey: NSLocale.Key.languageCode, value: languageCode)
        let englishCountryName = (englishLocale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: languageCode)
        
		return (languageName: englishLanguageName ?? "", countryName: englishCountryName ?? "")
	}
    
    class func allLanguages() -> [(languageCode: String, languageName: String?, countryName: String?)] {
        
        let languageCodes = ["bg", "ca", "ch", "ro"]
        var languages = [(languageCode: String, languageName: String?, countryName: String?)]()
        let englishLocale = Locale.init(identifier :  "en_US") as Locale
        
        for languageCode in languageCodes {
            
            let languageName = englishLocale.localizedString(forLanguageCode: languageCode)
            let countryName = englishLocale.localizedString(forRegionCode: languageCode)
                    
            languages.append((languageCode: languageCode, languageName: languageName, countryName: countryName))
        }
        
        return languages
    }
}
