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
	private var terms = [String]()
	private var lines = [Line]()
	private var translations = [String: String]()
	
    required init(url: NSURL) {
		super.init()
        self.url = url
		self.parseFile(url)
    }
	
	required init(content: String) {
		super.init()
		self.parseContent(content)
	}
	
    func allTerms() -> [String] {
        return terms
    }
    
    func translationForTerm(term: String) -> String {
        return translations[term]!
    }
    
    func updateTranslationForTerm(term: String, newValue: String) {
        
    }
	
	private func parseContent(content: String) {
		
		let lines = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
		for line in lines {
			parseLine(line)
		}
		print(lines)
		print(terms)
		print(translations)
	}
	
	private func parseFile(url: NSURL) {
		
		if let path = url.path {
			if let aStreamReader = StreamReader(path: path) {
				while let line = aStreamReader.nextLine() {
					parseLine(line)
				}
				aStreamReader.close()
			}
		}
		print(terms)
		print(translations)
	}
	
	func parseLine(line: String) {
		
		if line.hasPrefix("\"") && line.hasSuffix("\";") {
			let l = splitLine(line)
			lines.append(l)
			terms.append(l.key)
			translations[l.key] = l.value
		} else {
			lines.append((key: "", value: line, isComment: true))
		}
	}
	
	func splitLine(line: String) -> Line {
		
		let comps = line.componentsSeparatedByString("=")
		
		return (key: String(comps.first!.trim().characters.dropFirst().dropLast()),
				value: String(comps.last!.trim().characters.dropFirst().dropLast().dropLast()),
				isComment: false)
	}
}
