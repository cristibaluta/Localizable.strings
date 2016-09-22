//
//  StringExtenssion.swift
//  Localizabler
//
//  Created by Baluta Cristian on 06/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

extension String {
	
	@inline(__always) func trim() -> String {
		return self.trimmingCharacters(in: CharacterSet.whitespaces)
	}
}
