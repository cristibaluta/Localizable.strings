//
//  Wireframe.swift
//  Localizabler
//
//  Created by Baluta Cristian on 14/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class AppWireframe {

    private var windowController: WindowController!
    private var _appViewController: LocalizationsViewController?
    
    convenience init (windowController: WindowController) {
        self.init()
        self.windowController = windowController
    }
    
    fileprivate var localizationsViewController: LocalizationsViewController {
        get {
            if _appViewController != nil {
                return _appViewController!
            }
            _appViewController = LocalizationsViewController.instanceFromStoryboard()
            let presenter = LocalizationsPresenter()
            let interactor = LocalizationsInteractor()
            interactor.presenter = presenter
            presenter.userInterface = _appViewController
            presenter.interactor = interactor
            _appViewController!.presenter = presenter
            _appViewController!.wireframe = self
            
            return _appViewController!
        }
    }
    
    func presentLocalizationsInterface() -> LocalizationsViewController {
        
        self.windowController.contentViewController = localizationsViewController
        
        return localizationsViewController
    }
    
	func presentNoProjectsInterface() -> NoProjectViewController {
        
        let controller = NoProjectViewController.instanceFromStoryboard()
        self.windowController.contentViewController = controller
        
        return controller
	}
}
