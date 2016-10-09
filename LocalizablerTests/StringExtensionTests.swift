//
//  StringExtensionTests.swift
//  Localizabler
//
//  Created by Baluta Cristian on 06/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import XCTest
@testable import Localizable_strings

class StringExtensionTests: XCTestCase {

    func testTrim() {
        XCTAssert(" abc ".trim() == "abc", "Trim not working correctly")
    }
}
