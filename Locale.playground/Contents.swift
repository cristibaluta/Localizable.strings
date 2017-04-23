//: Playground - noun: a place where people can play

import Cocoa

let englishLocale = Locale.init(identifier : "en_US") as Locale
Locale.isoRegionCodes
Locale.preferredLanguages

englishLocale.localizedString(forIdentifier: "fr_MC")
(englishLocale as NSLocale).displayName(forKey: NSLocale.Key.identifier, value: "fr_MC")

//for languageCode in NSLocale.isoLanguageCodes {
//    
//    if let englishIdentifierName = englishLocale.displayName(forKey: NSLocale.Key.identifier, value: languageCode) {
//        englishCountryName = englishIdentifierName.slice(from: "(", to: ")")
//    }
//    print( "\(languageCode) \(englishLocale.localizedString(forLanguageCode: languageCode)) \(englishLocale.localizedString(forRegionCode: languageCode))" )
//}
