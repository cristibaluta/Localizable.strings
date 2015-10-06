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
		let path = NSBundle(forClass: self.dynamicType).URLForResource("test", withExtension: "strings")
		let data = NSData(contentsOfURL: path!)
		let fileContent = NSString(data: data!, encoding: NSUnicodeStringEncoding) as! String
		print(fileContent)
		let file = IOSLocalizationFile(content: fileContent)
		XCTAssert(file.allTerms().count == 3, "Wrong number of keys, check parsing")
	}
}
