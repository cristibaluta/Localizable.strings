//
//  WindowInteractor.swift
//  Localizabler
//
//  Created by Cristian Baluta on 08/10/16.
//  Copyright © 2016 Cristian Baluta. All rights reserved.
//

import Foundation

protocol WindowInteractorInput {
    
    func findLocalizationsInDirectory (url: URL) -> FilesResult
    func selectFileNamed (_ fileName: String) -> [String: URL]
    func search (_ searchString: String)
    func loadLocalizationsNamed (_ name: String)
}

protocol WindowInteractorOutput {
    
    
}

class WindowInteractor {
    
    var presenter: WindowInteractorOutput?
    
    fileprivate var allUrls: FilesResult = [String: [String: URL]]() // [filename: [language: URL]]
}

extension WindowInteractor: WindowInteractorInput {
    
    func findLocalizationsInDirectory (url: URL) -> FilesResult {
        
        allUrls = SearchIOSLocalizations().searchInDirectory(url)
        
        return allUrls
    }
    
    func selectFileNamed (_ fileName: String) -> [String: URL] {
        
        for (name, urls) in allUrls {
            if fileName == name {
                return urls
            }
        }
        return [:]
    }
    
    func search (_ searchString: String) {
        
    }
    
    func loadLocalizationsNamed (_ name: String) {
        
    }
}
