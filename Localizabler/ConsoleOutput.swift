//
//  ConsoleOutput.swift
//  Localizabler
//
//  Created by Baluta Cristian on 10/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class ConsoleOutput: Output {
	
	func write (_ string: String) {
		print("File content after changes is:")
		print(string)
	}
}
