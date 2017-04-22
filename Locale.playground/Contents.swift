//: Playground - noun: a place where people can play

import Cocoa

let englishLocale = Locale.init(identifier : "en_US") as Locale
Locale.isoRegionCodes
Locale.preferredLanguages

for languageCode in NSLocale.isoLanguageCodes {
    
    if let englishIdentifierName = englishLocale.displayName(forKey: NSLocale.Key.identifier, value: languageCode) {
        englishCountryName = englishIdentifierName.slice(from: "(", to: ")")
    }
    print( "\(languageCode) \(englishLocale.localizedString(forLanguageCode: languageCode)) \(englishLocale.localizedString(forRegionCode: languageCode))" )
}

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
    }
}