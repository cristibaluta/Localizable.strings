//
//  CountriesTests.swift
//  Localizabler
//
//  Created by Baluta Cristian on 10/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import XCTest
@testable import Localizabler

class CountriesTests: XCTestCase {

    func testValidCountries() {
		
		XCTAssert(CountryName.fromLanguageCode("Base").countryName == "", "Wrong country name")
        XCTAssert(CountryName.fromLanguageCode("ro").languageName == "Romanian", "Wrong country name")
        XCTAssert(CountryName.fromLanguageCode("ro").countryName == "Romania", "Wrong country name")
    }
}
