//
//  WindowPresenter.swift
//  Localizabler
//
//  Created by Cristian Baluta on 08/10/16.
//  Copyright © 2016 Cristian Baluta. All rights reserved.
//

import Cocoa

protocol WindowPresenterInput {
    
    func browseFiles()
    func loadLastOpenedProject()
    func openProjectAtUrl (_ url: URL)
    func selectFileNamed (_ fileName: String)
    func setLanguagesPopup (_ languages: [String])
    func selectLanguageNamed (_ fileName: String)
}

protocol WindowPresenterOutput {
    
    func setWindowTitle (_ title: String)
    func setFilenamesPopup (_ filenames: [String])
    func setLanguagesPopup (_ languages: [String])
    func selectFileNamed (_ filename: String)
    func selectLanguageNamed (_ language: String)
    func showNoProjectInterface()
    func showLocalizationsInterface (withUrls urls: [String: URL])
}

class WindowPresenter {
    
    var interactor: WindowInteractorInput?
    var userInterface: WindowPresenterOutput?
}

extension WindowPresenter: WindowPresenterInput {

    func browseFiles() {
        
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.begin { [weak self] (result) -> Void in
            
            if result == NSFileHandlingPanelOKButton {
                if let url = panel.urls.first {
                    History().setLastProjectDir(url)
                    self?.userInterface!.setWindowTitle(url.absoluteString)
                    self?.userInterface!.setFilenamesPopup([])
                    self?.userInterface!.setLanguagesPopup([])
                    self?.openProjectAtUrl(url)
                }
            }
        }
    }
    
    func loadLastOpenedProject() {
        
//        History().setLastProjectDir(nil)
        
        if let url = History().getLastProjectDir() {
            let _ = url.startAccessingSecurityScopedResource()
            openProjectAtUrl(url)
            url.stopAccessingSecurityScopedResource()
        } else {
            userInterface!.showNoProjectInterface()
        }
    }
    
    func openProjectAtUrl (_ url: URL) {
        
        userInterface!.setWindowTitle(url.absoluteString)
        
        let urls = interactor!.findLocalizationsInDirectory(url: url)
        let filenames = Array(urls.keys)
        userInterface!.setFilenamesPopup(filenames)
        
        if filenames.contains("Localizable.strings") {
            selectFileNamed("Localizable.strings")
        }
        else if let firstFile = filenames.first {
            selectFileNamed(firstFile)
        }
    }
    
    func selectFileNamed (_ fileName: String) {
        
        userInterface!.selectFileNamed(fileName)
        let urls = interactor!.selectFileNamed(fileName)
        userInterface!.showLocalizationsInterface(withUrls: urls)
    }
    
    func setLanguagesPopup (_ languages: [String]){
        userInterface!.setLanguagesPopup(languages)
    }
    
    func selectLanguageNamed (_ language: String) {
        userInterface!.selectLanguageNamed(language)
    }
}

extension WindowPresenter: WindowInteractorOutput {
    
    
}
