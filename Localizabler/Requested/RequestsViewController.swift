//
//  RequestsViewController.swift
//  Localizable.strings
//
//  Created by Cristian Baluta on 21/04/2017.
//  Copyright © 2017 Cristian Baluta. All rights reserved.
//

import Cocoa

class RequestsViewController: NSViewController {
    
    var presenter: RequestsPresenterInput?
    
    @IBOutlet weak fileprivate var splitView: NSSplitView?
    @IBOutlet weak fileprivate var termsTableView: NSTableView?
    @IBOutlet weak fileprivate var translationsTableView: NSTableView?
    
    class func instanceFromStoryboard() -> RequestsViewController {
        let storyBoard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        return storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "RequestsViewController")) as! RequestsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter!.setupDataSourceFor(termsTableView: termsTableView!,
                                      translationsTableView: translationsTableView!)
        presenter!.load()
    }
}

extension RequestsViewController: RequestsPresenterOutput {
    
}
