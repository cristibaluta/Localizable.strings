//
//  AppInteractor.swift
//  Localizabler
//
//  Created by Cristian Baluta on 07/10/16.
//  Copyright © 2016 Cristian Baluta. All rights reserved.
//

import Foundation

protocol LocalizationsInteractorInput {
    
    func loadUrls (_ name: [String: URL])
    func translationsForTerm (_ term: String) -> [TranslationData]
    func updateTerm (_ term: String, newTerm: String)
    func updateTranslation (_ translation: String, forTerm term: String, inLanguage language: String)
    func removeTerm (_ term: TermData)
    func insertNewTerm (afterIndex index: Int) -> (line: Line, row: Int)
    func search (_ searchString: String) -> (terms: [TermData], translations: [TranslationData])
    func saveChanges() -> Bool
    func languages() -> [String]
    func baseLanguage() -> String
    func termsForLanguage(_ language: String) -> [String]
    func lineMatchingTranslation (_ translation: String) -> Line?
}

protocol LocalizationsInteractorOutput: class {
    
    
}

class LocalizationsInteractor {
    
    weak var presenter: LocalizationsInteractorOutput?
    
    fileprivate var files = [String: LocalizationFile]() // [language: LocalizationFile]
    fileprivate var terms = [TermData]()
    fileprivate var translations = [TranslationData]()
    fileprivate var search: Search?
    fileprivate var activeLanguage: String = ""
    
    fileprivate func loadLocalizationFile (_ url: URL, countryCode: String) {
        
        do {
            files[countryCode] = try IOSLocalizationFile(url: url)
        }
        catch LocalizationFileError.fileNotFound(url) {
            RCLog("File not found \(url)")
        } catch {
            RCLog("Unknown error")
        }
    }
}

extension LocalizationsInteractor: LocalizationsInteractorInput {
    
    func loadUrls (_ urls: [String: URL]) {
        
        if let url = History().getLastProjectDir() {
            let _ = url.startAccessingSecurityScopedResource()
            
            files.removeAll()
            for (countryCode, url) in urls {
                loadLocalizationFile(url, countryCode: countryCode)
            }
            search = Search(files: files)
            
            
            url.stopAccessingSecurityScopedResource()
        }
    }
    
    func translationsForTerm (_ term: String) -> [TranslationData] {
        
        translations.removeAll()
        
        for (lang, localizationFile) in files {
            let data: TranslationData = (value: localizationFile.translationForTerm(term),
                                         newValue: nil,
                                         languageCode: lang)
            translations.append(data)
        }
        
        return translations
    }
    
    func updateTerm (_ term: String, newTerm: String) {
        for file in files.values {
            file.updateTerm(term, newValue: newTerm)
        }
    }
    
    func updateTranslation (_ translation: String, forTerm term: String, inLanguage language: String) {
        let file = files[language]
        file?.updateTranslationForTerm(term, newValue: translation)
    }
    
    func removeTerm (_ term: TermData) {
        for (_, localizationFile) in files {
            localizationFile.removeTerm(term)
        }
    }
    
//    func selectedTermRow (forTranslation translation: String) -> Int? {
    
//        if let line: Line = search!.lineMatchingTranslation(translation: translation) {
//            
//            let displayedTerms: [TermData] = self.termsTableDataSource!.data
//            var i = 0
//            var found = false
//            for term in displayedTerms {
//                if term.value == line.term {
//                    found = true
//                    break
//                }
//                i += 1
//            }
//            return i
//        }
//        return nil
//    }
    
    func search (_ searchString: String) -> (terms: [TermData], translations: [TranslationData]) {
        
        let search = Search(files: files)
        
        return (terms: search.searchInTerms(searchString),
                translations: search.searchInTranslations(searchString))
    }
    
    func saveChanges() -> Bool {
        return SaveChangesInteractor(files: files).execute()
    }
    
    func languages() -> [String] {
        return Array(files.keys).sorted()
    }
    
    func baseLanguage() -> String {
        
        let baseLanguage = BaseLanguage(files: files)
        var result = baseLanguage.get()
        if result.language == "" {
            if let (countryCode, file) = files.first {
                result = (language: countryCode, terms: file.allTerms())
            }
        }
        return result.language
    }
    
    func termsForLanguage(_ language: String) -> [String] {
        activeLanguage = language
        return files[language]!.allTerms()
    }
    
    func lineMatchingTranslation (_ translation: String) -> Line? {
        let search = Search(files: files)
        return search.lineMatchingTranslation(translation: translation)
    }
    
    func insertNewTerm (afterIndex index: Int) -> (line: Line, row: Int) {
        
        var row = index
        let allTerms = files[activeLanguage]!.allTerms()
        if row == -1 {
            row = allTerms.count - 1
        }
        let currentTerm = allTerms[row]
        let currentLine = files[activeLanguage]!.lineForTerm(currentTerm)
        
        let newTerm = "term \(arc4random())"
        let newLine: Line = (term: newTerm, translation: "", comment: nil)
        for (_, localizationFile) in files {
            localizationFile.addLine(newLine, belowLine: currentLine!)
        }
        return (line: newLine, row: row)
    }
    
}
