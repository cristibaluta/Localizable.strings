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
		XCTAssert(comps.translation == "value 1", "Translation is wrong")
    }
	
	func testKeysExtraction() {
		let path = NSBundle(forClass: self.dynamicType).URLForResource("test", withExtension: "strings")
		let data = NSData(contentsOfURL: path!)
		let s = NSString(data: data!, encoding: 1)
//		let string = try NSString(contentsOfURL: path!, encoding: 0) catch
		print(s)
		let file = IOSLocalizationFile(url: path!)
		XCTAssert(file.allTerms().count == 3, "Wrong number of keys, check parsing")
	}
}
