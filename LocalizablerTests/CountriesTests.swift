//
//  CountriesTests.swift
//  Localizabler
//
//  Created by Baluta Cristian on 10/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import XCTest

class CountriesTests: XCTestCase {

    func testValidCountries() {
		
		XCTAssert(CountryName.countryNameForLanguageCode("Base") == "United States of America", "Wrong country name")
		XCTAssert(CountryName.countryNameForLanguageCode("ro") == "Romania", "Wrong country name")
    }
}
