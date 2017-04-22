//
//  RequestTermsBuilder.swift
//  Localizable.strings
//
//  Created by Cristian Baluta on 22/04/2017.
//  Copyright © 2017 Cristian Baluta. All rights reserved.
//

import Foundation

class RequestTermsBuilder {
    
    func requestTerms (fromFile file: LocalizationFile) -> [RequestTerm] {
        
        var terms = [RequestTerm]()
        for line in file.allLines() {
            if line.term.characters.count > 0 {
                terms.append( RequestTerm(key: line.term, value: line.translation) )
            }
        }
        
        return terms
    }
}
