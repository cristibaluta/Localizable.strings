//
//  RequestsPresenter.swift
//  Localizable.strings
//
//  Created by Cristian Baluta on 21/04/2017.
//  Copyright © 2017 Cristian Baluta. All rights reserved.
//

import Cocoa

protocol RequestsPresenterInput {
    func setupDataSourceFor (termsTableView: NSTableView, translationsTableView: NSTableView)
    func load()
    func request()
}

protocol RequestsPresenterOutput {
    
}

class RequestsPresenter {
    
    var interactor: RequestsInteractorInput?
    var userInterface: RequestsPresenterOutput?
    
    fileprivate var termsTableDataSource: RequestsTermsDataSource?
    fileprivate var translationsTableDataSource: TranslationsTableDataSource?
}

extension RequestsPresenter: RequestsPresenterInput {
    
    func setupDataSourceFor (termsTableView: NSTableView, translationsTableView: NSTableView) {
        
        termsTableDataSource = RequestsTermsDataSource(tableView: termsTableView)
        translationsTableDataSource = TranslationsTableDataSource(tableView: translationsTableView)
        
        termsTableDataSource?.onDidSelectRow = { [weak self] (rowNumber: Int, key: RequestTerm) -> Void in
            
            guard let wself = self else {
                return
            }
            
//            let translations = wself.interactor!.translationsForTerm(key.value)
//            wself.translationsTableDataSource?.data = translations
//            wself.translationsTableDataSource?.reloadData()
//            wself.updatePlaceholders(withMessage: "No selection")
        }
        
        translationsTableDataSource?.translationDidChange = { [weak self] (translation: Translation) -> Void in
            
            guard let wself = self else {
                return
            }
            
            // A translation was changed, update the term object so it knows about the change
//            var selectedRow = wself.userInterface!.selectedTermRow()!
//            if selectedRow < 0 {
//                selectedRow = wself.lastHighlightedTermRow
//            }
//            guard selectedRow >= 0 else {
//                return
//            }
//            
//            let termData = wself.termsTableDataSource?.data[selectedRow]
//            wself.termsTableDataSource?.data[selectedRow].translationChanged = true
//            
//            // If there are changes in the translation
//            if let newValue = translation.newValue {
//                wself.interactor!.updateTranslation(newValue,
//                                                    forTerm: termData!.value,
//                                                    inLanguage: translation.languageCode)
//            }
//            
//            wself.userInterface!.reloadTerm(atIndex: selectedRow)
//            wself.userInterface!.enableSaving()
        }
        translationsTableDataSource?.translationDidBecomeFirstResponder = { [weak self] (value: String) -> Void in
            
            guard let wself = self else {
                return
            }
//            guard wself.lastSearchString != "" else {
//                return
//            }
//            
//            if let line: Line = wself.interactor!.lineMatchingTranslation(value) {
//                
//                guard line.term.characters.count > 0 else {
//                    return
//                }
//                
//                let displayedTerms: [TermData] = wself.termsTableDataSource!.data
//                var i = 0
//                var found = false
//                for term in displayedTerms {
//                    if term.value == line.term {
//                        found = true
//                        break
//                    }
//                    i += 1
//                }
//                wself.lastHighlightedTermRow = i
//                wself.termsTableDataSource!.highlightedRow = i
//                if !found {
//                    wself.termsTableDataSource?.data.append((value: line.term, newValue: nil, translationChanged: false) as TermData)
//                }
//                wself.termsTableDataSource?.reloadData()
//            }
        }
    }
    
    func load() {
        CloudKitRepository.shared.readMySubmittedTerms { [weak self] terms in
            if let terms = terms {
                RCLog(terms)
                self?.termsTableDataSource?.data = terms
                self?.termsTableDataSource?.reloadData()
            }
        }
    }
    
    func request() {
        let t: [RequestTerm] = [RequestTerm(key: "key1", value: "value1")]
        CloudKitRepository.shared.write(terms: t)
    }
}

extension RequestsPresenter: RequestsInteractorOutput {
    
}
