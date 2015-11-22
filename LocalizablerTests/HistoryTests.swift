//
//  LastProjectTests.swift
//  Localizabler
//
//  Created by Baluta Cristian on 31/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import XCTest
@testable import Localizabler

class HistoryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        History().setLastProjectDir(nil)
    }
    
    override func tearDown() {
		History().setLastProjectDir(nil)
        super.tearDown()
    }
    
    func testNoLastProject() {
		
        let lastProject = History()
		XCTAssert(lastProject.getLastProjectDir() == nil, "Initially history is empty")
	}
	
	func testLastProject() {
		
		let lastProject = History()
		lastProject.setLastProjectDir("some/dir")
		XCTAssert(lastProject.getLastProjectDir() == "some/dir", "Value should be some/dir")
    }
}
