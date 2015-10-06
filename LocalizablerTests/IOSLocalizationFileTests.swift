//
//  IOSLocalizationFileTests.swift
//  Localizabler
//
//  Created by Baluta Cristian on 02/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import XCTest
@testable import Localizabler

class IOSLocalizationFileTests: XCTestCase {
	
    func testExample() {
		let file = IOSLocalizationFile(url: NSURL())
		file.splitLine("")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
