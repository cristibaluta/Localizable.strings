//
//  RegisterViewController.swift
//  Localizable.strings
//
//  Created by Cristian Baluta on 21/04/2017.
//  Copyright © 2017 Cristian Baluta. All rights reserved.
//

import Cocoa

class RegisterViewController: NSViewController {
    
    var presenter: RegisterPresenterInput?
    weak var wireframe: AppWireframe?
    
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var languagesPopUp: NSPopUpButton!
    @IBOutlet weak var butRegister: NSButton!
    @IBOutlet weak var validationErrorTextField: NSTextField!
    
    class func instanceFromStoryboard() -> RegisterViewController {
        let storyBoard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        return storyBoard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "RegisterViewController")) as! RegisterViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter!.setupUI()
    }
    
    @IBAction func handleRegister (_ sender: NSButton) {
        validationErrorTextField.stringValue = ""
        presenter!.register(name: nameTextField.stringValue, languageNr: languagesPopUp.indexOfSelectedItem)
    }
}

extension RegisterViewController: RegisterPresenterOutput {
    
    func validationFailed (message: String) {
        validationErrorTextField.stringValue = message
    }
    
    func setLanguages (languages: [String]) {
        languagesPopUp.removeAllItems()
        languagesPopUp.addItems(withTitles: languages)
    }
}
