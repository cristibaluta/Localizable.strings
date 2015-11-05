//
//  LastProjectTests.swift
//  Localizabler
//
//  Created by Baluta Cristian on 31/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import XCTest

class LastProjectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        History().setLastProjectDir(nil)
    }
    
    override func tearDown() {
		History().setLastProjectDir(nil)
        super.tearDown()
    }
    
    func testLastProject() {
		
        let lastProject = History()
		XCTAssert(lastProject.getLastProjectDir() == nil, "Initially should be no value")
		
		lastProject.setLastProjectDir("some/dir")
		XCTAssert(lastProject.getLastProjectDir() == "some/dir", "Value should be some/dir")
    }
}
