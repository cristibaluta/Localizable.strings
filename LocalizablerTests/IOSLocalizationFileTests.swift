//
//  IOSLocalizationFileTests.swift
//  Localizabler
//
//  Created by Baluta Cristian on 02/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import XCTest
@testable import Localizable_strings

class IOSLocalizationFileTests: XCTestCase {
	/*
    func testKeyValueSeparation() {
        
        let url = Bundle(for: type(of: self)).url(forResource: "test", withExtension: "strings")
        let file = try! IOSLocalizationFile(url: url!)
		let comps = file.splitLine("\"key1\" = \"value 1\";")
		XCTAssert(comps.term == "key1", "Key is wrong")
		XCTAssert(comps.translation == "value 1", "Translation is wrong")
    }
	
	func testKeysExtraction() {
		
		let url = Bundle(for: type(of: self)).url(forResource: "test", withExtension: "strings")
		let file = try! IOSLocalizationFile(url: url!)
        let lines = file.allLines()
		XCTAssert(lines.count == 9, "Wrong number of lines, check parsing")
        XCTAssertTrue(lines[5].term == "key3")
        XCTAssertTrue(lines[5].translation == "value 3")
        XCTAssertTrue(lines[5].comment == " // Inline comment 2")
		XCTAssert(file.allTerms().count == 4, "Wrong number of keys, check parsing")
		XCTAssert(file.translationForTerm("key1") == "value 1", "Wrong dictionary")
		XCTAssert(file.translationForTerm("key2") == "value 2", "Wrong dictionary")
        XCTAssert(file.translationForTerm("key3") == "value 3", "Wrong dictionary")
        XCTAssert(file.translationForTerm("key4").hasPrefix("<html><head>"), "Splitting of line failed")
        XCTAssert(file.translationForTerm("key4").hasSuffix("</body></html>"), "Splitting of html line failed")
	}
	
	func testValidLines() {
        
        let url = Bundle(for: type(of: self)).url(forResource: "test", withExtension: "strings")
        let file = try! IOSLocalizationFile(url: url!)
		XCTAssertFalse(file.isValidLine(""), "")
		XCTAssertFalse(file.isValidLine("// Comment"), "")
		XCTAssertFalse(file.isValidLine("\"\"=\"\""), "Missing termination character ;")
		XCTAssertFalse(file.isValidLine("\";"), "Missing equal is not allowed")
		XCTAssertFalse(file.isValidLine("\"\"=\"\";"), "Missing keys are not allowed")
        
        XCTAssertTrue(file.isValidLine("\"key\"=\"ใช้คีย์ลัดเดิม\";"), "Thai chars not matched, probably the string range is using string.characters.length instead string.utf16.length")
		XCTAssertTrue(file.isValidLine("\"key\"=\"\";"), "Missing spaces are allowed")
		XCTAssertTrue(file.isValidLine("   \"key\"=\"\";"), "Spaces at the beginning are allowed")
		XCTAssertTrue(file.isValidLine("   \"key\"=\"\";   "), "Spaces at the beginning and end are allowed")
		XCTAssertTrue(file.isValidLine("\"key\" =    \"value\";"), "Spaces around = sign are allowed")
		XCTAssertTrue(file.isValidLine("\"key key\" =    \"value value value value \";"), "")
		XCTAssertTrue(file.isValidLine("\"The key \"%@\" can't.\" = \"The key \"%@\" can't be used <html> \"; %@.\";"),
		              "Html in the right side allowed. This includes termination character ;")
        
	}
    
    func testLineWithComment() {
        
        let url = Bundle(for: type(of: self)).url(forResource: "test", withExtension: "strings")
        let file = try! IOSLocalizationFile(url: url!)
        XCTAssertTrue(file.isValidLine("\"The key\" = \"The translation\"; /* The comment */"),
                      "Line with comment should be valid")
    }*/
}
