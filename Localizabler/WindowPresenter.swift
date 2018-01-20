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
    func selectScreen (_ i: Int)
}

protocol WindowPresenterOutput {
    
    func setWindowTitle (_ title: String)
}

class WindowPresenter {
    
    var appWireframe: AppWireframe?
    var userInterface: WindowPresenterOutput?
    
    fileprivate var allUrls: FilesResult = [String: [String: URL]]() // [filename: [language: URL]]
}

extension WindowPresenter: WindowPresenterInput {

    func selectScreen (_ i: Int) {
        switch i {
        case 0:
            showLocalizationsInterface(withFilesResult: allUrls)
            break
        case 1:
            showRequestsInterface()
            break
        case 2:
            showCommunityInterface()
            break
        default:
            break
        }
    }
    
    func browseFiles() {
        
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.begin { [weak self] (result) -> Void in
            
            if result.rawValue == NSFileHandlingPanelOKButton {
                if let url = panel.urls.first {
                    History().setLastProjectDir(url)
                    self?.userInterface!.setWindowTitle(url.absoluteString)
                    self?.openProjectAtUrl(url)
                }
            }
        }
    }
    
    func loadLastOpenedProject() {
        
        if let url = History().getLastProjectDir() {
            let _ = url.startAccessingSecurityScopedResource()
            openProjectAtUrl(url)
            url.stopAccessingSecurityScopedResource()
        } else {
            showNoProjectInterface()
        }
    }
    
    func openProjectAtUrl (_ url: URL) {
        
        userInterface!.setWindowTitle(url.absoluteString)
        
        allUrls = SearchIOSLocalizations().searchInDirectory(url)
        showLocalizationsInterface(withFilesResult: allUrls)
    }
}

extension WindowPresenter {
    
    fileprivate func showNoProjectInterface() {
        
        let noProjectsController = appWireframe!.presentNoProjectsInterface()
        noProjectsController.onOpenButtonClicked = handleOpenButton
    }
    
    fileprivate func handleOpenButton (_ sender: NSButton) {
        browseFiles()
    }
    
    fileprivate func showLocalizationsInterface (withFilesResult result: FilesResult) {
        
        let localizationsController = appWireframe!.presentLocalizationsInterface()
        localizationsController.windowPresenter = self
        localizationsController.presenter!.openProjectWithFilesResult(result)
    }
    
    fileprivate func showRequestsInterface() {
        CloudKitRepository.shared.getUser { (user) in
            if user != nil {
                _ = self.appWireframe!.presentRequestsInterface()
            } else {
                self.showRegisterInterface()
            }
        }
    }
    
    fileprivate func showCommunityInterface() {
        CloudKitRepository.shared.getUser { (user) in
            if user != nil {
                _ = self.appWireframe!.presentCommunityInterface()
            } else {
                self.showRegisterInterface()
            }
        }
    }
    
    fileprivate func showRegisterInterface() {
        _ = appWireframe!.presentRegisterInterface()
    }
}
