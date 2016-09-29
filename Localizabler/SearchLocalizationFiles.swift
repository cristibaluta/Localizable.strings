//
//  SearchLocalizations.swift
//  Localizabler
//
//  Created by Cristian Baluta on 02/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

protocol SearchLocalizationFiles {
    
    func searchInDirectory (_ dir: URL) -> [String: URL]
}
