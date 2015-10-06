//
//  StringExtensionTests.swift
//  Localizabler
//
//  Created by Baluta Cristian on 06/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import XCTest

class StringExtensionTests: XCTestCase {

    func testTrim() {
        XCTAssert(" abc ".trim() == "abc", "Trim not working correctly")
    }
}
