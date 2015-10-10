//
//  Save.swift
//  Localizabler
//
//  Created by Baluta Cristian on 09/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class Save: NSObject {
	
	required init(files: [String: LocalizationFile]) {
		super.init()
		
		saveToDisk(files)
//		showToConsole(files)
	}
	
	func saveToDisk(files: [String: LocalizationFile]) {
		
		for (_, file) in files {
			if file.hasChanges {
				_ = FileOutput(url: file.url!).write(file.content())
			}
		}
	}
	
	func showToConsole(files: [String: LocalizationFile]) {
		
		for (_, file) in files {
			if file.hasChanges {
				_ = ConsoleOutput().write(file.content())
			}
		}
	}
}
