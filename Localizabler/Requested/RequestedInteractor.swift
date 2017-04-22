//
//  RequestedInteractor.swift
//  Localizable.strings
//
//  Created by Cristian Baluta on 21/04/2017.
//  Copyright © 2017 Cristian Baluta. All rights reserved.
//

import Foundation

protocol RequestedInteractorInput {
    
}

protocol RequestedInteractorOutput {
    
}

class RequestedInteractor {
    
    var presenter: RequestedInteractorOutput?
}

extension RequestedInteractor: RequestedInteractorInput {
    
}
