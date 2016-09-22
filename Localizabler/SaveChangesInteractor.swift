//
//  Save.swift
//  Localizabler
//
//  Created by Baluta Cristian on 09/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class SaveChangesInteractor: NSObject {
	
	var files: [String: LocalizationFile]?
	
	required init (files: [String: LocalizationFile]) {
		super.init()
		self.files = files
	}
	
	func execute() -> Bool {
		saveToDisk(files!)
		//		showToConsole(files!)
		return true
	}
	
	fileprivate func saveToDisk (_ files: [String: LocalizationFile]) {
		
		for (_, file) in files {
			if file.hasChanges {
				let output = FileOutput(url: file.url!)
					output.write(file.content())
			}
		}
	}
	
	fileprivate func showToConsole (_ files: [String: LocalizationFile]) {
		
		for (_, file) in files {
			if file.hasChanges {
				_ = ConsoleOutput().write(file.content())
			}
		}
	}
}
