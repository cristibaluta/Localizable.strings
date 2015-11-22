//
//  LastProject.swift
//  Localizabler
//
//  Created by Baluta Cristian on 31/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class History: NSObject {
	
	let kLastProjectDir = "kLastProjectDir"
	
	func getLastProjectDir() -> String? {
		return NSUserDefaults.standardUserDefaults().objectForKey(kLastProjectDir) as? String
	}
	
	func setLastProjectDir (dir: String?) {
		NSUserDefaults.standardUserDefaults().setObject(dir, forKey: kLastProjectDir)
		NSUserDefaults.standardUserDefaults().synchronize()
	}
}
