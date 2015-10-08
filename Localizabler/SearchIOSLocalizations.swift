//
//  SearchIOSLocalizations.swift
//  Localizabler
//
//  Created by Cristian Baluta on 02/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class SearchIOSLocalizations: NSObject, SearchLocalizations {
	
	let suffix = ".lproj/"
	let localizationFile = "Localizable.strings"

    func searchInDirectory(dir: NSURL, result: [String: NSURL] -> Void) {
        
        let fileManager = NSFileManager.defaultManager()
        do {
            let files = try fileManager.contentsOfDirectoryAtURL(dir, includingPropertiesForKeys: nil,
                options: NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants)
            var resultDict = [String: NSURL]()
            for file in files {
                if file.absoluteString.hasSuffix(suffix) {
                    let comps = file.absoluteString.componentsSeparatedByString(suffix)
                    let comps2 = comps.first!.componentsSeparatedByString("/")
                    resultDict[comps2.last!] = file.URLByAppendingPathComponent(localizationFile)
                }
            }
            result(resultDict)
        } catch {
            RCLogO("some error while reading files")
        }
    }
}
