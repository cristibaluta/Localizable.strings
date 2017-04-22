//
//  RegisterPresenter.swift
//  Localizable.strings
//
//  Created by Cristian Baluta on 21/04/2017.
//  Copyright © 2017 Cristian Baluta. All rights reserved.
//

import Foundation

protocol RegisterPresenterInput: class {
    func register (name: String, languageNr: Int)
    func setupUI()
}

protocol RegisterPresenterOutput: class {
    func validationFailed (message: String)
    func setLanguages (languages: [String])
}

class RegisterPresenter {
    
    var interactor: RegisterInteractorInput?
    weak var userInterface: RegisterPresenterOutput?
    
    fileprivate var languages = CountryName.allLanguages()
}

extension RegisterPresenter: RegisterPresenterInput {
    
    func setupUI() {
        var items = [String]()
        for lang in languages {
            items.append("(\(lang.languageCode)) \(lang.languageName ?? "") - \(lang.countryName ?? "")")
        }
        userInterface!.setLanguages (languages: items)
    }
    
    func register (name: String, languageNr: Int) {
        
        guard name != "" else {
            userInterface!.validationFailed(message: "Please provide a name so people recognize you!")
            return
        }
        
        interactor?.register(name: name, languageCode: languages[languageNr].languageCode)
    }
}

extension RegisterPresenter: RegisterInteractorOutput {
    
    func didSucceedRegister() {
        
    }
    
    func didFailRegister() {
        
    }
}
