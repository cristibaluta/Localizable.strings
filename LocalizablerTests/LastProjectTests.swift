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
        LastProject().set(nil)
    }
    
    override func tearDown() {
		LastProject().set(nil)
        super.tearDown()
    }
    
    func testExample() {
        let lastProject = LastProject()
		XCTAssert(lastProject.get() == nil, "Initially should be no value")
		
		lastProject.set("some/dir")
		XCTAssert(lastProject.get() == "some/dir", "Value should be some/dir")
    }
    
}
