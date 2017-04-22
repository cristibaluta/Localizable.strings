//
//  Wireframe.swift
//  Localizabler
//
//  Created by Baluta Cristian on 14/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class AppWireframe {

    fileprivate var windowController: WindowController!
    fileprivate var _localizationsViewController: LocalizationsViewController?
    
    convenience init (windowController: WindowController) {
        self.init()
        self.windowController = windowController
    }
    
    func presentLocalizationsInterface() -> LocalizationsViewController {
        
        self.windowController.contentViewController = localizationsViewController
        
        return localizationsViewController
    }
    
    func presentRegisterInterface() -> RegisterViewController {
        
        let controller = registerViewController
        self.windowController.contentViewController = controller
        
        return controller
    }
    
    func presentRequestedInterface() -> RequestedViewController {
        
        let controller = requestedViewController
        self.windowController.contentViewController = controller
        
        return controller
    }
    
    func presentCommunityInterface() -> CommunityViewController {
        
        let controller = communityViewController
        self.windowController.contentViewController = controller
        
        return controller
    }
    
	func presentNoProjectsInterface() -> NoProjectViewController {
        
        let controller = NoProjectViewController.instanceFromStoryboard()
        self.windowController.contentViewController = controller
        
        return controller
	}
}

extension AppWireframe {
    
    fileprivate var localizationsViewController: LocalizationsViewController {
        get {
            if _localizationsViewController != nil {
                return _localizationsViewController!
            }
            _localizationsViewController = LocalizationsViewController.instanceFromStoryboard()
            let presenter = LocalizationsPresenter()
            let interactor = LocalizationsInteractor()
            interactor.presenter = presenter
            presenter.userInterface = _localizationsViewController
            presenter.interactor = interactor
            _localizationsViewController!.presenter = presenter
            _localizationsViewController!.wireframe = self
            
            return _localizationsViewController!
        }
    }
    
    fileprivate var registerViewController: RegisterViewController {
        get {
            let controller = RegisterViewController.instanceFromStoryboard()
            let presenter = RegisterPresenter()
            let interactor = RegisterInteractor()
            interactor.presenter = presenter
            presenter.userInterface = controller
            presenter.interactor = interactor
            controller.presenter = presenter
            controller.wireframe = self
            
            return controller
        }
    }
    
    fileprivate var requestedViewController: RequestedViewController {
        get {
            let controller = RequestedViewController.instanceFromStoryboard()
            let presenter = RequestedPresenter()
            let interactor = RequestedInteractor()
            interactor.presenter = presenter
            presenter.userInterface = controller
            presenter.interactor = interactor
            controller.presenter = presenter
//            controller.wireframe = self
            
            return controller
        }
    }
    
    fileprivate var communityViewController: CommunityViewController {
        get {
            let controller = CommunityViewController.instanceFromStoryboard()
            let presenter = CommunityPresenter()
            let interactor = CommunityInteractor()
            interactor.presenter = presenter
            presenter.userInterface = controller
            presenter.interactor = interactor
            controller.presenter = presenter
//            controller.wireframe = self
            
            return controller
        }
    }
    
}
