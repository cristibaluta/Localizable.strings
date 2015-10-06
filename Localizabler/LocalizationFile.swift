//
//  Terms.swift
//  Localizabler
//
//  Created by Cristian Baluta on 02/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

protocol LocalizationFile {

	init(url: NSURL)
	init(content: String)
    func allTerms() -> [String]
    func translationForTerm(term: String) -> String
    func updateTranslationForTerm(term: String, newValue: String)
}
