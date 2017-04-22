//
//  CommunityInteractor.swift
//  Localizable.strings
//
//  Created by Cristian Baluta on 21/04/2017.
//  Copyright © 2017 Cristian Baluta. All rights reserved.
//

import Foundation

protocol CommunityInteractorInput {
    
}

protocol CommunityInteractorOutput {
    
}

class CommunityInteractor {
    
    var presenter: CommunityInteractorOutput?
}

extension CommunityInteractor: CommunityInteractorInput {
    
}
