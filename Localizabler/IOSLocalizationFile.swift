//
//  IOSLocalizationFile.swift
//  Localizabler
//
//  Created by Cristian Baluta on 02/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class IOSLocalizationFile: NSObject, LocalizationFile {
	
	var url: NSURL?
	var hasChanges: Bool = false
	private var terms = [String]()
	private var lines = [Line]()
	private var translations = [String: String]()
	private let regex = try? NSRegularExpression(pattern: "^(\"|[ ]*\")([^\"]+)\"(^|[ ]*)=(^|[ ]*)\"(.*?)\"(;|;[ ]*)$",
												 options: NSRegularExpressionOptions())
	
    required init(url: NSURL) {
		super.init()
		
		self.url = url
		
		if url.path != nil {
			if let data = NSData(contentsOfURL: url) {
				if let fileContent = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
					self.parseContent(fileContent)
				}
				else if let fileContent = NSString(data: data, encoding: NSUnicodeStringEncoding) as? String {
					self.parseContent(fileContent)
				}
			} else {
				RCLog("Can't open this file \(url.path)")
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
        return translations[term] ?? ""
    }
    
    func updateTranslationForTerm(term: String, newValue: String) {
        translations[term] = newValue
		hasChanges = true
    }
	
	func content() -> String {
		
		var string = ""
		
		// Iterate over lines and put them back in the string with the new translations
        var i = 0
		for line in lines {
			if line.isComment {
				string += line.translation
			}
			else {
				string += "\"\(line.term)\" = \"\(translationForTerm(line.term))\";"
			}
            i++
            if i < lines.count {
                string += "\n"
            }
		}
		
		return string
	}
	
	
	// MARK: Helpers
	
	private func parseContent(content: String) {
		
		let lines = content.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
		for line in lines {
			parseLine(line)
		}
	}
	
	@inline(__always) func parseLine(lineContent: String) {
		
		if isValidLine(lineContent) {
			let line = splitLine(lineContent)
			lines.append(line)
			terms.append(line.term)
			translations[line.term] = line.translation
		} else {
			lines.append((term: "", translation: lineContent, isComment: true))
		}
	}
	
	@inline(__always) func isValidLine(lineContent: String) -> Bool {
		return regex!.matchesInString(lineContent, options: NSMatchingOptions(),
			range: NSMakeRange(0, lineContent.characters.count)).count == 1
	}
	
	@inline(__always) func splitLine(lineContent: String) -> Line {
		
		// TODO: split with regex
		let comps = lineContent.componentsSeparatedByString("=")
		
		return (term:			String(comps.first!.trim().characters.dropFirst().dropLast()),
				translation:	String(comps.last!.trim().characters.dropFirst().dropLast().dropLast()),
				isComment:		false)
	}
}
