//
//  CountriesTests.swift
//  Localizabler
//
//  Created by Baluta Cristian on 10/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import XCTest
@testable import Localizable_strings

class CountriesTests: XCTestCase {

    func testValidCountries() {
		
		XCTAssert(Countries.languageName(fromLanguageCode: "Base").countryName == "", "Wrong country name")
        XCTAssert(Countries.languageName(fromLanguageCode: "ro").languageName == "Romanian", "Wrong language name")
        XCTAssert(Countries.languageName(fromLanguageCode: "ro").countryName == "Romania", "Wrong country name")
        
        XCTAssert(Countries.languageName(fromLanguageCode: "fr_CH").languageName == "French")
        XCTAssert(Countries.languageName(fromLanguageCode: "fr_CH").countryName == "Switzerland")
        
        XCTAssert(Countries.languageName(fromLanguageCode: "fr_MC").languageName == "French")
        XCTAssert(Countries.languageName(fromLanguageCode: "fr_MC").countryName == "Monaco")
        
        XCTAssert(Countries.languageName(fromLanguageCode: "fr").languageName == "French")
        XCTAssert(Countries.languageName(fromLanguageCode: "fr").countryName == "France")
        
        XCTAssert(Countries.languageName(fromLanguageCode: "sv").languageName == "Swedish")
        XCTAssert(Countries.languageName(fromLanguageCode: "sv").countryName == "Sweden")
    }
}
