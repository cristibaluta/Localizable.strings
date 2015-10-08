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
	@IBOutlet var keysTableView: NSTableView?
	@IBOutlet var valuesTableView: NSTableView?
	
	var keysTableViewDataSource = KeysTableViewDataSource()
	var valuesTableViewDataSource = KeysTableViewDataSource()
	var languages = [String: LocalizationFile]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		let win = NSApplication.sharedApplication().windows.first
//		win?.titleVisibility = NSWindowTitleVisibility.Hidden;
		
		keysTableView?.setDataSource( keysTableViewDataSource )
		keysTableView?.setDelegate( keysTableViewDataSource )
		valuesTableView?.setDataSource( valuesTableViewDataSource )
		valuesTableView?.setDelegate( valuesTableViewDataSource )
		
		// Do any additional setup after loading the view.
		if let dir = NSUserDefaults.standardUserDefaults().objectForKey("localizationsDirectory") {
            self.pathControl!.URL = dir as? NSURL
            self.scanDirectoryForLocalizationfiles()
        }
    }
    
    @IBAction func chosePathClicked(sender: NSButton) {
		
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false;
        panel.beginWithCompletionHandler { (result) -> Void in
            RCLogO(result)
            if result == NSFileHandlingPanelOKButton {
                print(panel.URLs.first)
                self.pathControl!.URL = panel.URLs.first
//                NSUserDefaults.standardUserDefaults().setObject(panel.URLs.first, forKey: "localizationsDirectory")
//                NSUserDefaults.standardUserDefaults().synchronize()
                self.scanDirectoryForLocalizationfiles()
				self.showDefaultLanguage()
            }
        }
    }
    
    func scanDirectoryForLocalizationfiles() {
        
        _ = SearchIOSLocalizations().searchInDirectory(self.pathControl!.URL!) { (localizationsDict) -> Void in
            RCLogO(localizationsDict)
            self.segmentedControl!.segmentCount = localizationsDict.count
            var i = 0
            for (key, url) in localizationsDict {
				self.loadLocalizationFile(url, forKey: key)
                self.segmentedControl?.setLabel(key, forSegment: i)
                i++
            }
        }
    }
    
	func loadLocalizationFile(url: NSURL, forKey key: String) {
        self.languages[key] = IOSLocalizationFile(url: url)
    }
	
	func showDefaultLanguage() {
		
		var keys = [String]()
		if let file = languages["Base"] {
			keys = file.allTerms()
		}
		else if let file = languages["en"] {
			keys = file.allTerms()
		}
		RCLogO(keys)
		RCLogO(nil)
		keysTableViewDataSource.data = keys
		keysTableView?.reloadData()
	}
}
