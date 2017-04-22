//
//  RequestsInteractor.swift
//  Localizable.strings
//
//  Created by Cristian Baluta on 21/04/2017.
//  Copyright © 2017 Cristian Baluta. All rights reserved.
//

import Foundation

protocol RequestsInteractorInput {
    
}

protocol RequestsInteractorOutput {
    
}

class RequestsInteractor {
    
    var presenter: RequestsInteractorOutput?
}

extension RequestsInteractor: RequestsInteractorInput {
    
}
