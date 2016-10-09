//
//  AppPresenter.swift
//  Localizabler
//
//  Created by Cristian Baluta on 04/10/16.
//  Copyright © 2016 Cristian Baluta. All rights reserved.
//

import Cocoa

protocol LocalizationsPresenterInput {
    
    func setupDataSourceFor (termsTableView: NSTableView, translationsTableView: NSTableView)
    func loadUrls (_ urls: [String: URL])
    func insertNewTerm (afterIndex index: Int)
    func removeTerm (atIndex index: Int)
    func search (_ searchString: String)
    func saveChanges()
    func selectLanguageNamed (_ fileName: String)
}

protocol LocalizationsPresenterOutput: class {
    
    func updatePlaceholders (message: String, hideTerms: Bool, hideTranslations: Bool)
    func showNoProjectInterface()
    func enableSaving()
    func disableSaving()
    func insertNewTerm (atIndex index: Int)
    func removeTerm (atIndex index: Int)
    func reloadTerm (atIndex index: Int)
    func selectedTermRow() -> Int?
    func showLanguagesPopup (_ languages: [String])
    func selectLanguage (_ language: String)
    func selectTerm (atRow row: Int)
    func deselectActiveTerm()
}

class LocalizationsPresenter {
    
    var interactor: LocalizationsInteractorInput?
    weak var userInterface: LocalizationsPresenterOutput?
    
    fileprivate var termsTableDataSource: TermsTableDataSource?
    fileprivate var translationsTableDataSource: TranslationsTableDataSource?
    
    fileprivate func markFilesAsSaved() {
        
        for i in 0..<self.termsTableDataSource!.data.count {
            termsTableDataSource?.data[i].translationChanged = false
        }
        termsTableDataSource?.reloadData()
    }
    
}

extension LocalizationsPresenter: LocalizationsPresenterInput {
    
    func setupDataSourceFor (termsTableView: NSTableView, translationsTableView: NSTableView) {
        
        termsTableDataSource = TermsTableDataSource(tableView: termsTableView)
        translationsTableDataSource = TranslationsTableDataSource(tableView: translationsTableView)
        
        termsTableDataSource?.onDidSelectRow = { [weak self] (rowNumber: Int, key: TermData) -> Void in
            
            guard let wself = self else {
                return
            }
            
            let translations = wself.interactor!.translationsForTerm(key.value)
            wself.translationsTableDataSource?.data = translations
            wself.translationsTableDataSource?.reloadData()
            wself.updatePlaceholders(withMessage: "No selection")
        }
        termsTableDataSource?.termDidChange = { [weak self] (term: TermData) -> Void in
            
            guard let wself = self else {
                return
            }
            
            // A term was changed, update the value
            if let newValue = term.newValue {
                wself.interactor!.updateTerm(term.value, newTerm: newValue)
                wself.userInterface!.enableSaving()
            }
        }
        
        translationsTableDataSource?.translationDidChange = { [weak self] (translation: TranslationData) -> Void in
            
            guard let wself = self else {
                return
            }
            
            // A translation was changed, update the term object so it knows about the change
            if let selectedRow = wself.userInterface!.selectedTermRow(), selectedRow >= 0 {
                let termData = wself.termsTableDataSource?.data[selectedRow]
                wself.termsTableDataSource?.data[selectedRow].translationChanged = true
                
                // If there are changes in the translation
                if let newValue = translation.newValue {
                    wself.interactor!.updateTranslation(newValue,
                                                        forTerm: termData!.value,
                                                        inLanguage: translation.languageCode)
                }
                
                wself.userInterface!.reloadTerm(atIndex: selectedRow)
                wself.userInterface!.enableSaving()
            }
        }
        translationsTableDataSource?.translationDidBecomeFirstResponder = { [weak self] (value: String) -> Void in
            
            guard let wself = self else {
                return
            }
            
            if let line: Line = wself.interactor!.lineMatchingTranslation(value) {
            
                let displayedTerms: [TermData] = wself.termsTableDataSource!.data
                var i = 0
                var found = false
                for term in displayedTerms {
                    if term.value == line.term {
                        found = true
                        break
                    }
                    i += 1
                }
                wself.termsTableDataSource!.highlightedRow = i
                if !found {
                    wself.termsTableDataSource?.data.append((value: line.term, newValue: nil, translationChanged: false) as TermData)
                }
                wself.termsTableDataSource?.reloadData()
                wself.userInterface!.selectTerm(atRow: i)
            }
        }
    }
    
    func loadUrls (_ urls: [String: URL]) {
        
        interactor!.loadUrls(urls)
        let languages = interactor!.languages()
        userInterface!.showLanguagesPopup(languages)
        showBaseLanguage()
    }
    
    func insertNewTerm (afterIndex index: Int) {
        
        let data = interactor!.insertNewTerm(afterIndex: index)
        let termData: TermData = (value: data.line.term, newValue: nil, translationChanged: false)
        termsTableDataSource!.data.insert(termData, at: data.row + 1)
        termsTableDataSource!.reloadData()
        userInterface!.selectTerm(atRow: data.row + 1)
        userInterface!.enableSaving()
    }
    
    func removeTerm (atIndex index: Int) {
        
        // Remove from files
        let term: TermData = termsTableDataSource!.data[index]
        interactor!.removeTerm(term)
        // Remove from datasource
        termsTableDataSource?.data.remove(at: index)
        termsTableDataSource!.reloadData()
        userInterface!.enableSaving()
    }
    
    fileprivate func clear() {
        
        userInterface!.deselectActiveTerm()
        translationsTableDataSource?.data = []
        translationsTableDataSource?.reloadData()
    }
    
    func showTerms (_ terms: [String]) {
        
        clear()
        
        var termsData = [TermData]()
        for term in terms {
            termsData.append((value: term, newValue: nil, translationChanged: false) as TermData)
        }
        
        termsTableDataSource?.data = termsData
        termsTableDataSource?.reloadData()
        updatePlaceholders(withMessage: "No selection")
    }
    
    func search (_ searchString: String) {
        
        userInterface!.deselectActiveTerm()
        let results = interactor!.search(searchString)
        //
        termsTableDataSource?.data = results.terms
        termsTableDataSource?.reloadData()
        //
        translationsTableDataSource?.data = results.translations
        translationsTableDataSource?.reloadData()
        
        // Add Placeholders if no matches found
        updatePlaceholders(withMessage: "No matches")
    }
    
    func showBaseLanguage() {
        
        let baseLanguage = interactor!.baseLanguage()
        userInterface!.selectLanguage(baseLanguage)
        selectLanguageNamed(baseLanguage)
    }
    
    func saveChanges() {
        
        if interactor!.saveChanges() {
            markFilesAsSaved()
            userInterface!.disableSaving()
        }
    }
    
    func selectLanguageNamed (_ fileName: String) {
        let terms = interactor!.termsForLanguage(fileName)
        showTerms(terms)
    }
}

extension LocalizationsPresenter {
    
    fileprivate func updatePlaceholders(withMessage message: String) {
        
        userInterface!.updatePlaceholders(message: message,
                                          hideTerms: translationsTableDataSource!.data.count > 0,
                                          hideTranslations: termsTableDataSource!.data.count > 0)
    }
    
}

extension LocalizationsPresenter: LocalizationsInteractorOutput {
    
}
