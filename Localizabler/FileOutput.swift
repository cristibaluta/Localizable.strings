//
//  FileOutput.swift
//  Localizabler
//
//  Created by Baluta Cristian on 10/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class FileOutput: NSObject, Output {

	fileprivate var url: URL?
	
	required init (url: URL) {
		super.init()
		self.url = url
	}
	
	func write (_ string: String) {
		do {
			try string.write(to: url!, atomically: true, encoding: String.Encoding.utf8)
		}
		catch let error as NSError {
			print(error.localizedDescription)
		}
	}
}
