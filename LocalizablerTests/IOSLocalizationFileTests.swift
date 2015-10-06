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
	
    func testKeyValueSeparation() {
		let file = IOSLocalizationFile(url: NSURL())
		let comps = file.splitLine("\"key1\" = \"value 1\";")
		XCTAssert(comps.key == "key1", "Key is wrong")
		XCTAssert(comps.value == "value 1", "Translation is wrong")
    }
	
	func testKeysExtraction() {
		let url = NSBundle(forClass: self.dynamicType).URLForResource("test", withExtension: "strings")
		let file = IOSLocalizationFile(url: url!)
		XCTAssert(file.allTerms().count == 3, "Wrong number of keys, check parsing")
		XCTAssert(file.translationForTerm("key1") == "value 1", "Wrong dictionary")
		XCTAssert(file.translationForTerm("key2") == "value 2", "Wrong dictionary")
		XCTAssert(file.translationForTerm("key3") == "value 3", "Wrong dictionary")
	}
}
