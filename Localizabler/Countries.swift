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
		"nl": "Netherlands"
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
