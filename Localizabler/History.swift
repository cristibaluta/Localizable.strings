//
//  LastProject.swift
//  Localizabler
//
//  Created by Baluta Cristian on 31/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class History {
	
	let lastProjectDir = "LastProjectDir"
	
	func getLastProjectDir() -> String? {
		return UserDefaults.standard.object(forKey: lastProjectDir) as? String
	}
	
	func setLastProjectDir (_ dir: String?) {
		UserDefaults.standard.set(dir, forKey: lastProjectDir)
		UserDefaults.standard.synchronize()
	}
}
