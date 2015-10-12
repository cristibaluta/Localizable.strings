//
//  Countries.swift
//  Localizabler
//
//  Created by Baluta Cristian on 10/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class Countries: NSObject {

	static var countries = [
		"Base": "United States of America",
		"en": "England",
		"ro": "Romania",
		"fr": "France",
		"nl": "Netherlands",
		"fi": "Finland",
		"nn": "Norway",
		"no": "Norway",
		"es": "Spain",
		"pt": "Portugal",
		"de": "Germany",
		"zh": "China",
		"zh-Hans": "China",
		"zh-Hant": "China",
		"it": "Italy",
		"ko": "South Korea",
		"da": "Denmark",
		"ja": "Japan",
		"tr": "Turkey",
		"ms": "Japan"
	]
	
	class func countryNameForCode(countryCode: String) -> String {
		
		if let countryName = countries[countryCode] {
			return countryName
		} else {
			RCLog("Country code \(countryCode) was not found in the dictionary, please add it")
			return ""
		}
	}
}
