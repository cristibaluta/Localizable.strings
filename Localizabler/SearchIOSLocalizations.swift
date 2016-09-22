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

    func searchInDirectory (_ dir: URL, result: ([String: URL]) -> Void) {
        
        let fileManager = FileManager.default
        do {
            let files = try fileManager.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil,
                options: FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants)
            var resultDict = [String: URL]()
            for file in files {
                if file.absoluteString.hasSuffix(suffix) {
                    let comps = file.absoluteString.components(separatedBy: suffix)
                    let comps2 = comps.first!.components(separatedBy: "/")
                    resultDict[comps2.last!] = file.appendingPathComponent(localizationFile)
                }
            }
            result(resultDict)
        } catch {
            RCLog("some error while reading files")
        }
    }
}
