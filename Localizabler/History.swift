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
		return UserDefaults.standard.object(forKey: kLastProjectDir) as? String
	}
	
	func setLastProjectDir (_ dir: String?) {
		UserDefaults.standard.set(dir, forKey: kLastProjectDir)
		UserDefaults.standard.synchronize()
	}
}
