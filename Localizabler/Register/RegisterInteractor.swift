//
//  RegisterInteractor.swift
//  Localizable.strings
//
//  Created by Cristian Baluta on 21/04/2017.
//  Copyright © 2017 Cristian Baluta. All rights reserved.
//

import Foundation

protocol RegisterInteractorInput: class {
    func register (name: String, languageCode: String)
}

protocol RegisterInteractorOutput: class {
    func didSucceedRegister()
    func didFailRegister()
}

class RegisterInteractor {
    
    weak var presenter: RegisterInteractorOutput?
}

extension RegisterInteractor: RegisterInteractorInput {
    
    func register (name: String, languageCode: String) {
        CloudKitRepository().updateUser(name: name, languageCode: languageCode)
    }
}
