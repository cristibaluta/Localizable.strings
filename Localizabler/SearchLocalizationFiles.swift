//
//  SearchLocalizations.swift
//  Localizabler
//
//  Created by Cristian Baluta on 02/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

typealias FilesResult = [String: [String: URL]]// [filename: [language: url]]

protocol SearchLocalizationFiles {
    
    func searchInDirectory (_ dir: URL) -> FilesResult
}
