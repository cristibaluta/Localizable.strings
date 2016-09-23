//
//  Countries.swift
//  Localizabler
//
//  Created by Baluta Cristian on 10/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class CountryName {
	
	class func countryNameForLanguageCode (_ localeIdentifier: String) -> String {
		
		// init an english NSLocale to get the english name of all NSLocale-Objects
		let englishLocale : Locale = Locale.init(identifier :  "en_US")
		
		let theEnglishName = (englishLocale as NSLocale).displayName(forKey: NSLocale.Key.identifier, value: localeIdentifier)
		
//		let locale = NSLocale(localeIdentifier: localeIdentifier)
//		let displayName = locale.displayNameForKey(NSLocaleIdentifier, value: "en_US")
//		RCLog(displayName)
//		
//		let localeDisplayName = locale.displayNameForKey(NSLocaleIdentifier, value: localeIdentifier)
//		RCLog(localeDisplayName)
//		
//		let currentLocale = NSLocale(localeIdentifier: localeIdentifier)
//		let countryCode = currentLocale.objectForKey(NSLocaleCountryCode)
//		let usLocale = NSLocale(localeIdentifier: "en_US")
//		let country = usLocale.displayNameForKey(NSLocaleCountryCode, value: countryCode ?? "")
//		RCLog("\(countryCode) \(country)")
		
//		NSLocale *locale = [NSLocale currentLocale];
//		NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
//		NSLocale *usLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
//		NSString *country = [usLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
		
		return theEnglishName ?? ""
	}
}
