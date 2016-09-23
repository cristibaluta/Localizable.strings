//
//  IOSLocalizationFile.swift
//  Localizabler
//
//  Created by Cristian Baluta on 02/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Foundation

class IOSLocalizationFile: LocalizationFile {
	
	var url: URL?
	var hasChanges: Bool = false
	fileprivate var lines = [Line]()
	fileprivate var terms = [String: String]()
	fileprivate var translations = [String: String]()
	fileprivate let regex = try? NSRegularExpression(pattern: "^(\"|[ ]*\")(.+?)\"(^|[ ]*)=(^|[ ]*)\"(.*?)\"(;|;[ ]*)$",
												 options: NSRegularExpression.Options())
	
    required init (url: URL) throws {
		self.url = url
        if let data = try? Data(contentsOf: url) {
            if let fileContent = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String {
                self.parseContent(fileContent)
            }
            else if let fileContent = NSString(data: data, encoding: String.Encoding.unicode.rawValue) as? String {
                self.parseContent(fileContent)
            }
        } else {
            throw(LocalizationFileError.fileNotFound(url: url))
        }
    }
	
	required init (content: String) {
		self.parseContent(content)
	}
	
	// Set
	func updateTerm (_ term: String, newValue: String) {
		terms[term] = newValue
		hasChanges = true
	}
    
    func updateTranslationForTerm (_ term: String, newValue: String) {
        translations[term] = newValue
		hasChanges = true
    }
	
	func addLine (_ line: Line) {
		lines.append(line)
		terms[line.term] = line.term
		translations[line.term] = line.translation
	}
	
	// Get
	func allLines() -> [Line] {
		return lines
	}
	
	func allTerms() -> [String] {
		return Array(terms.keys)
	}
	
	func translationForTerm (_ term: String) -> String {
		return translations[term] ?? ""
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
				string += "\"\(terms[line.term]!)\" = \"\(translationForTerm(line.term))\";"
			}
            i += 1
            if i < lines.count {
                string += "\n"
            }
		}
		
		return string
	}
	
	
	// MARK: Helpers
	
	fileprivate func parseContent (_ content: String) {
		
		let lines = content.components(separatedBy: CharacterSet.newlines)
		for line in lines {
			parseLine(line)
		}
	}
	
	@inline(__always) func parseLine (_ lineContent: String) {
		
		if isValidLine(lineContent) {
			addLine(splitLine(lineContent))
		} else {
			lines.append((term: "", translation: lineContent, isComment: true))
		}
	}
	
	@inline(__always) func isValidLine (_ lineContent: String) -> Bool {
		return regex!.matches(in: lineContent, options: NSRegularExpression.MatchingOptions(),
			range: NSMakeRange(0, lineContent.characters.count)).count == 1
	}
	
	@inline(__always) func splitLine (_ lineContent: String) -> Line {
		
		// TODO: split with regex
		let comps = lineContent.components(separatedBy: "=")
		
		return (term:			String(comps.first!.trim().characters.dropFirst().dropLast()),
				translation:	String(comps.last!.trim().characters.dropFirst().dropLast().dropLast()),
				isComment:		false)
	}
}
