//
//  NSObject_Extension.swift
//
//  Created by Cristian Baluta on 25/11/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

extension NSObject {
    class func pluginDidLoad(bundle: NSBundle) {
        let appName = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? NSString
        if appName == "Xcode" {
        	if sharedPlugin == nil {
        		sharedPlugin = LocalizablerXcodePlugin(bundle: bundle)
        	}
        }
    }
}