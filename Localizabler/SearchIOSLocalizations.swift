//
//  SearchIOSLocalizations.swift
//  Localizabler
//
//  Created by Cristian Baluta on 02/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class SearchIOSLocalizations: SearchLocalizationFiles {
	
	private let lproj = ".lproj/"
	private let strings = ".strings"
    
    func searchInDirectory (_ dir: URL) -> FilesResult {
        
        let fileManager = FileManager.default
        let resourceKeys = [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey]
        let directoryEnumerator = fileManager.enumerator(at: dir,
                                                         includingPropertiesForKeys: resourceKeys,
                                                         options: [.skipsHiddenFiles],
                                                         errorHandler: nil)!
 
        var files = [String: [String: URL]]()
        
        for case let fileURL as NSURL in directoryEnumerator {
            guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
                let isDirectory = resourceValues[URLResourceKey.isDirectoryKey] as? Bool,
                let name = resourceValues[URLResourceKey.nameKey] as? String
                else {
                    continue
            }
            
            if isDirectory {
                if name.hasSuffix("xcodeproj") {
                    directoryEnumerator.skipDescendants()
                }
            } else {
                if fileURL.absoluteString!.contains(lproj) && name.hasSuffix(strings) {
                    var file: [String: URL]? = files[name]
                    if file == nil {
                        file = [String: URL]()
                    }
                    let language = languageOfPath(path: fileURL.absoluteString!)
                    file![language] = fileURL as URL
                    files[name] = file!
                }
            }
        }
        RCLog(files)
        return files
    }
    
    @inline(__always) private func languageOfPath (path: String) -> String {
        let comps = path.components(separatedBy: lproj)
        let comps2 = comps.first!.components(separatedBy: "/")
        return comps2.last!
    }
}
