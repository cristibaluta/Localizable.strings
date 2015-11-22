//
//  ConsoleOutput.swift
//  Localizabler
//
//  Created by Baluta Cristian on 10/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class ConsoleOutput: NSObject, Output {
	
	func write (string: String) {
		RCLog("File content after changes is:")
		print(string)
	}
}
