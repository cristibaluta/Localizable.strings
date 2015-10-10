//
//  FileOutput.swift
//  Localizabler
//
//  Created by Baluta Cristian on 10/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class FileOutput: NSObject, Output {

	private var url: NSURL?
	
	required init(url: NSURL) {
		super.init()
		self.url = url
	}
	
	func write(string: String) {
		do {
			try string.writeToURL(url!, atomically: true, encoding: NSUTF8StringEncoding)
		}
		catch let error as NSError {
			print(error.localizedDescription)
		}
	}
}
