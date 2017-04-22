//
//  RequestedPresenter.swift
//  Localizable.strings
//
//  Created by Cristian Baluta on 21/04/2017.
//  Copyright © 2017 Cristian Baluta. All rights reserved.
//

import Foundation

protocol RequestedPresenterInput {
    
}

protocol RequestedPresenterOutput {
    
}

class RequestedPresenter {
    
    var interactor: RequestedInteractorInput?
    var userInterface: RequestedPresenterOutput?
}

extension RequestedPresenter: RequestedPresenterInput {
    
}

extension RequestedPresenter: RequestedInteractorOutput {
    
}
