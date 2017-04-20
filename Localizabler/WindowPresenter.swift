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
}

protocol WindowPresenterOutput {
    
    func setWindowTitle (_ title: String)
    func showNoProjectInterface()
    func showLocalizationsInterface (withFilesResult result: FilesResult)
}

class WindowPresenter {
    
    var userInterface: WindowPresenterOutput?
    fileprivate var allUrls: FilesResult = [String: [String: URL]]() // [filename: [language: URL]]
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
        
        allUrls = SearchIOSLocalizations().searchInDirectory(url)
        userInterface!.showLocalizationsInterface(withFilesResult: allUrls)
//        let filenames = Array(allUrls.keys)
//        userInterface!.setFilenamesPopup(filenames)
//        
//        if filenames.contains("Localizable.strings") {
//            selectFileNamed("Localizable.strings")
//        }
//        else if let firstFile = filenames.first {
//            selectFileNamed(firstFile)
//        }
    }
}
