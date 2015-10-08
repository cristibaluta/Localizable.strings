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
		if url.path != nil {
			let data = NSData(contentsOfURL: url)
			if let fileContent = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String {
				self.parseContent(fileContent)
			}
			else if let fileContent = NSString(data: data!, encoding: NSUnicodeStringEncoding) as? String {
				self.parseContent(fileContent)
			}
		}
    }
	
	required init(content: String) {
		super.init()
		self.parseContent(content)
	}
	
	func allLines() -> [Line] {
		return lines
	}
	
    func allTerms() -> [String] {
        return terms
    }
    
    func translationForTerm(term: String) -> String {
        return translations[term]!
    }
    
    func updateTranslationForTerm(term: String, newValue: String) {
        translations[term] = newValue
    }
	
	private func parseContent(content: String) {
		
		let lines = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
		for line in lines {
			parseLine(line)
		}
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
	}
	
	@inline(__always) func parseLine(lineContent: String) {
		
		if isValidLine(lineContent) {
			let line = splitLine(lineContent)
			lines.append(line)
			terms.append(line.key)
			translations[line.key] = line.value
		} else {
			lines.append((key: "", value: lineContent, isComment: true))
		}
	}
	
	@inline(__always) func isValidLine(lineContent: String) -> Bool {
		return lineContent.hasPrefix("\"") && lineContent.hasSuffix("\";")
	}
	
	@inline(__always) func splitLine(lineContent: String) -> Line {
		
		let comps = lineContent.componentsSeparatedByString("=")
		
		return (key: String(comps.first!.trim().characters.dropFirst().dropLast()),
				value: String(comps.last!.trim().characters.dropFirst().dropLast().dropLast()),
				isComment: false)
	}
}
