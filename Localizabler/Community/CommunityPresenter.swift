//
//  CommunityPresenter.swift
//  Localizable.strings
//
//  Created by Cristian Baluta on 21/04/2017.
//  Copyright © 2017 Cristian Baluta. All rights reserved.
//

import Foundation

protocol CommunityPresenterInput {
    
}

protocol CommunityPresenterOutput {
    
}

class CommunityPresenter {
    
    var interactor: CommunityInteractorInput?
    var userInterface: CommunityPresenterOutput?
}

extension CommunityPresenter: CommunityPresenterInput {
    
}

extension CommunityPresenter: CommunityInteractorOutput {
    
}
