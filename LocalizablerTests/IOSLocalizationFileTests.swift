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
		
		let file = try! IOSLocalizationFile(url: NSURL())
		let comps = file.splitLine("\"key1\" = \"value 1\";")
		XCTAssert(comps.term == "key1", "Key is wrong")
		XCTAssert(comps.translation == "value 1", "Translation is wrong")
    }
	
	func testKeysExtraction() {
		
		let url = NSBundle(forClass: self.dynamicType).URLForResource("test", withExtension: "strings")
		let file = try! IOSLocalizationFile(url: url!)
		XCTAssert(file.allLines().count == 7, "Wrong number of lines, check parsing")
		XCTAssert(file.allTerms().count == 3, "Wrong number of keys, check parsing")
		XCTAssert(file.translationForTerm("key1") == "value 1", "Wrong dictionary")
		XCTAssert(file.translationForTerm("key2") == "value 2", "Wrong dictionary")
		XCTAssert(file.translationForTerm("key3") == "value 3", "Wrong dictionary")
	}
	
	func testValidLines() {
		
		let file = try? IOSLocalizationFile(url: NSURL())
		XCTAssertFalse(file!.isValidLine(""), "")
		XCTAssertFalse(file!.isValidLine("// Comment"), "")
		XCTAssertFalse(file!.isValidLine("\"\"=\"\""), "")
		XCTAssertFalse(file!.isValidLine("\";"), "")
		XCTAssertFalse(file!.isValidLine("\"\"=\"\";"), "")
		XCTAssertTrue(file!.isValidLine("\"key\"=\"\";"), "")
		XCTAssertTrue(file!.isValidLine("   \"key\"=\"\";"), "")
		XCTAssertTrue(file!.isValidLine("   \"key\"=\"\";   "), "")
		XCTAssertTrue(file!.isValidLine("\"key\" =    \"value\";"), "")
		XCTAssertTrue(file!.isValidLine("\"key key\" =    \"value value value value \";"), "")
		XCTAssertTrue(file!.isValidLine("\"The key \"%@\" can't %@.\" = \"The key \"%@\" can't be used because %@.\";"), "")
	}
}
