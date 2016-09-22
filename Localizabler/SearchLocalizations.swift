//
//  SearchLocalizations.swift
//  Localizabler
//
//  Created by Cristian Baluta on 02/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

protocol SearchLocalizations {
    
    func searchInDirectory (_ dir: URL, result: ([String: URL]) -> Void)
}
