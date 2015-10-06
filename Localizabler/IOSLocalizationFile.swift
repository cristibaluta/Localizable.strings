//
//  IOSLocalizationFile.swift
//  Localizabler
//
//  Created by Cristian Baluta on 02/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class IOSLocalizationFile: NSObject, LocalizationFile {
	
	private var url: NSURL?
    private var content: String = ""
	private var terms = [String]()
	private var translations = [String: String]()
	
    required init(url: NSURL) {
		super.init()
        self.url = url
		self.processFile()
    }
	
	required init(content: String) {
		super.init()
		self.content = content
//		self.processContent()
	}
	
    func allTerms() -> [String] {
        return terms
    }
    
    func translationForTerm(term: String) -> String {
        return translations[term]!
    }
    
    func updateTranslationForTerm(term: String, newValue: String) {
        
    }
	
	private func processFile() {
		
		if let aStreamReader = StreamReader(path: url!.path!) {
			while let line = aStreamReader.nextLine() {
				if line.hasPrefix("\"") {
					let group = splitLine(line)
					print(group)
				}
			}
			aStreamReader.close()
		}
	}
	
	private func splitLine(line: String) -> (key: String, translation: String) {
		
		let comps = line.componentsSeparatedByString(" = ")
		
		return (key: String(comps.first!.characters.dropFirst().dropLast()), translation: comps.last!)
	}
}
