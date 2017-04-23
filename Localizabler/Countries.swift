//
//  Countries.swift
//  Localizabler
//
//  Created by Baluta Cristian on 10/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class Countries {
	
    static let exceptions = [
        "sv": "Sweden",
        "da": "Denmark",
        "ja": "Japan",
        "en": "United States of America",
        "el": "Greece",
        "ko": "North Korea",
        "cs": "Czech Republic",
        "hans": "China",
        "hant": "China"
    ]
    
    class func languageName (fromLanguageCode languageCode: String) -> (languageName: String, countryName: String) {
        
        // init an english Locale to get the english name of the language and country
        let englishLocale = Locale.init(identifier :  "en_US")
        var comps = languageCode.components(separatedBy: "_")
        if comps.count == 1 {
            comps = languageCode.components(separatedBy: "-")
        }
        let languageCode = comps.first!
        let regionCode = comps.last!
        
        let englishLanguageName = englishLocale.localizedString(forLanguageCode: languageCode)
        var englishCountryName = englishLocale.localizedString(forRegionCode: regionCode)
        if let countryName = exceptions[regionCode.lowercased()] {
            englishCountryName = countryName
        }
        
        return (languageName: englishLanguageName ?? "", countryName: englishCountryName ?? "")
	}
    
    class func allLanguages() -> [(languageCode: String, languageName: String?, countryName: String?)] {
        
        let languageCodes = ["ca", "ch", "cs", "da", "de", "el", "en", "es", "fr", "it", "ja", "ko", "nb", "nl", "pl", "pt", "ro", "ru", "sk", "sv", "th", "zh"]
        
        var languages = [(languageCode: String, languageName: String?, countryName: String?)]()
        
        for languageCode in languageCodes {
            let comp = languageName(fromLanguageCode: languageCode)
            languages.append( (languageCode: languageCode, languageName: comp.languageName, countryName: comp.countryName) )
        }
        
        return languages
    }
}
