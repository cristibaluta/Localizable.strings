//
//  FileUrls.swift
//  Localizable.strings
//
//  Created by Cristian Baluta on 21/04/2017.
//  Copyright © 2017 Cristian Baluta. All rights reserved.
//

import Foundation

class FileUrls {
    
    fileprivate var files: FilesResult
    
    init(files: FilesResult) {
        self.files = files
    }
    func urls (forFileName fileName: String) -> [String: URL] {
        
        for (name, urls) in files {
            if fileName == name {
                return urls
            }
        }
        return [:]
    }
}
