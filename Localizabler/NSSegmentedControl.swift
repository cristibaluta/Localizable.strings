//
//  NSSegmentedControl.swift
//  Localizabler
//
//  Created by Baluta Cristian on 11/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

extension NSSegmentedControl {

	func selectSegmentWithLabel(label: String) {
		
		for i in 0...self.segmentCount {
			if self.labelForSegment(i) == label {
				self.selectedSegment = i
				break
			}
		}
	}
}
