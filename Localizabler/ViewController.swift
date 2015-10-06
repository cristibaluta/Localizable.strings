//
//  ViewController.swift
//  Localizabler
//
//  Created by Cristian Baluta on 01/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var pathControl: NSPathControl?
    @IBOutlet var segmentedControl: NSSegmentedControl?
	var languages = [String: LocalizationFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let dir = NSUserDefaults.standardUserDefaults().objectForKey("localizationsDirectory") {
            self.pathControl!.URL = dir as! NSURL
            self.readDirectoryForLocalizationfiles()
        }
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func chosePathClicked(sender: NSButton) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false;
        panel.beginWithCompletionHandler { (result) -> Void in
            print(result)
            if result == NSFileHandlingPanelOKButton {
                print(panel.URLs.first)
                self.pathControl!.URL = panel.URLs.first
//                NSUserDefaults.standardUserDefaults().setObject(panel.URLs.first, forKey: "localizationsDirectory")
//                NSUserDefaults.standardUserDefaults().synchronize()
                self.readDirectoryForLocalizationfiles()
            }
        }
    }
    
    func readDirectoryForLocalizationfiles() {
        
        _ = SearchIOSLocalizations().searchInDirectory(self.pathControl!.URL!) { (localizationsDict) -> Void in
            print(localizationsDict)
            self.segmentedControl!.segmentCount = localizationsDict.count
            var i = 0
            for (key, url) in localizationsDict {
				self.languages[key] = IOSLocalizationFile(url: url)
                self.segmentedControl?.setLabel(key, forSegment: i)
                i++
            }
        }
    }
    
    func readFile(url: NSURL) {
        
//        let data = NSFileManager.defaultManager().contentsAtPath(url.path!)
//        print(data)
        
        
    }
}
