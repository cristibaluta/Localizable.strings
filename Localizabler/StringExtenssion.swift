//
//  StringExtenssion.swift
//  Localizabler
//
//  Created by Baluta Cristian on 06/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

extension String {
	
	func trim() -> String {
		return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
	}
}
