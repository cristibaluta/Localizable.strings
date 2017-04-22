//
//  RequestTermsBuilder.swift
//  Localizable.strings
//
//  Created by Cristian Baluta on 22/04/2017.
//  Copyright © 2017 Cristian Baluta. All rights reserved.
//

import Foundation

class RequestTermsBuilder {
    
    func requestTerms (fromTermData termsData: [Term]) -> [RequestTerm] {
        
        var terms = [RequestTerm]()
        for term in termsData {
            terms.append( RequestTerm(key: term.value, value: "") )
        }
        
        return terms
    }
}
