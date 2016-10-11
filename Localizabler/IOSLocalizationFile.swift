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
	fileprivate var terms = [String: String]()// term: value
	fileprivate var translations = [String: String]()// term: translation
    // Regex to validate a line containing term and translation
	fileprivate let lineRegex = try? NSRegularExpression(pattern: "^(\"|[ ]*\")(.+?)\"(^|[ ]*)=(^|[ ]*)\"(.*?)(\";)",
	                                                     options: NSRegularExpression.Options())
    fileprivate let separatorRegex = try? NSRegularExpression(pattern: "\"(^|[ ]*)=(^|[ ]*)\"",
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
        hasChanges = true
	}
    
    func addLine(_ line: Line, belowLine: Line) {
        
        var index = indexOf(line: belowLine) + 1
        if index > lines.count {
            index = lines.count
        }
        lines.insert(line, at: index)
        terms[line.term] = line.term
        translations[line.term] = line.translation
        hasChanges = true
    }
    
    func removeTerm(_ term: TermData) {
        
        if let lineIndex = lines.index( where: { $0.term == term.value || $0.term == term.newValue } ) {
            lines.remove(at: lineIndex)
        }
        terms.removeValue(forKey: term.value)
        translations.removeValue(forKey: term.value)
        if let newValue = term.newValue {
            terms.removeValue(forKey: newValue)
            translations.removeValue(forKey: newValue)
        }
        hasChanges = true
    }
	
	// Get
	func allLines() -> [Line] {
		return lines
	}
	
	func allTerms() -> [String] {
        var terms = [String]()
        for line in lines {
            if line.term.characters.count > 0 {
                terms.append(line.term)
            }
        }
		return terms
	}
    
    func lineForTerm (_ term: String) -> Line? {
        for line in lines {
            if line.term == term {
                return line
            }
        }
        return nil
    }
    
	func translationForTerm (_ term: String) -> String {
		return translations[term] ?? ""
	}
	
	func content() -> String {
		
		var string = ""
		
		// Iterate over lines and put them back in the string with the new translations
        var i = 0
		for line in lines {
			if line.comment != nil && line.term.utf16.count > 0 && translationForTerm(line.term).utf16.count > 0 {
				string += line.comment!
			}
			else {
                let comment = line.comment != nil ? line.comment : ""
				string += "\"\(terms[line.term]!)\" = \"\(translationForTerm(line.term))\";\(comment)"
			}
            i += 1
            if i < lines.count {
                string += "\n"
            }
		}
		
		return string
	}
}

extension IOSLocalizationFile {
	
    fileprivate func indexOf (line: Line) -> Int {
        var index = 0
        for line_ in lines {
            if line.term == line_.term {
                break
            }
            index += 1
        }
        return index
    }
    
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
			lines.append((term: "", translation: "", comment: lineContent))
		}
	}
	
	@inline(__always) func isValidLine (_ lineContent: String) -> Bool {
        
		return lineRegex!.numberOfMatches(in: lineContent,
		                                  options: NSRegularExpression.MatchingOptions(),
		                                  range: NSMakeRange(0, lineContent.utf16.count)) == 1
	}
	
	@inline(__always) func splitLine (_ lineContent: String) -> Line {
		
		// TODO: Better splitting
        let translationMatch = lineRegex!.firstMatch(in: lineContent,
                                                     options: NSRegularExpression.MatchingOptions(),
                                                     range: NSMakeRange(0, lineContent.utf16.count))
        let theTranslation = (lineContent as NSString?)?.substring(with: translationMatch!.range)
        let theComment: String? = (translationMatch!.range.length < lineContent.utf16.count)
        ? (lineContent as NSString?)!.substring(with: NSMakeRange(translationMatch!.range.length, lineContent.utf16.count-translationMatch!.range.length))
        : nil
        let separator = separatorRegex!.firstMatch(in: theTranslation!,
                                                   options: NSRegularExpression.MatchingOptions(),
                                                   range: NSMakeRange(0, theTranslation!.utf16.count))
        let nsString = theTranslation as! NSString
        let newLineContent = nsString.replacingCharacters(in: separator!.range, with: "::separator::")
        let c = newLineContent.components(separatedBy: theTranslation!)
		let comps = c.last!.components(separatedBy: "::separator::")
		
		return (term:			String(comps.first!.trim().characters.dropFirst()),
				translation:	String(comps.last!.trim().characters.dropLast().dropLast()),
				comment:		theComment)
	}
}
