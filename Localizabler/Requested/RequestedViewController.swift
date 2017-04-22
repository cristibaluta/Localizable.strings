//
//  RequestedViewController.swift
//  Localizable.strings
//
//  Created by Cristian Baluta on 21/04/2017.
//  Copyright © 2017 Cristian Baluta. All rights reserved.
//

import Cocoa

class RequestedViewController: NSViewController {
    
    var presenter: RequestedPresenterInput?
    
    class func instanceFromStoryboard() -> RequestedViewController {
        let storyBoard = NSStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateController(withIdentifier: "RequestedViewController") as! RequestedViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension RequestedViewController: RequestedPresenterOutput {
    
}
