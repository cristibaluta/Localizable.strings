//
//  ViewController.swift
//  Localizabler
//
//  Created by Cristian Baluta on 01/10/15.
//  Copyright © 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class AppViewController: NSViewController {
	
	@IBOutlet fileprivate var languagesPopup: NSPopUpButton?
	@IBOutlet var splitView: NSSplitView?
	@IBOutlet fileprivate var termsTableView: NSTableView?
	@IBOutlet fileprivate var translationsTableView: NSTableView?
    @IBOutlet fileprivate var butSave: NSButton?
	
	fileprivate var termsTableAlert: InlinedAlertView?
	fileprivate var translationsTableAlert: InlinedAlertView?
	fileprivate var termsTableDataSource: TermsTableDataSource?
	fileprivate var translationsTableDataSource: TranslationsTableDataSource?
	var url: URL?
    fileprivate var files = [String: [String: LocalizationFile]]()// [filename: [language: File]]
    var selectedFiles = [String: LocalizationFile]()
	fileprivate var allTerms = [TermData]()
	fileprivate var allTranslations = [TranslationData]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        termsTableView?.backgroundColor = NSColor.clear
        butSave?.isEnabled = false
		
		termsTableDataSource = TermsTableDataSource(tableView: termsTableView!)
		translationsTableDataSource = TranslationsTableDataSource(tableView: translationsTableView!)
		
		termsTableDataSource?.onDidSelectRow = { [weak self] (rowNumber: Int, key: TermData) -> Void in
			
			guard let wself = self else {
				return
			}
			
			wself.allTranslations = [TranslationData]()
			
			for (lang, localizationFile) in wself.selectedFiles {
                let data: TranslationData = (value: localizationFile.translationForTerm(key.value),
                                             newValue: nil,
                                             languageCode: lang)
				wself.allTranslations.append(data)
			}
			wself.translationsTableDataSource?.data = wself.allTranslations
			wself.translationsTableView?.reloadData()
			wself.updateAlerts("No selection")
		}
		termsTableDataSource?.termDidChange = { [weak self] (term: TermData) -> Void in
			
			guard let wself = self else {
				return
			}
			
			// A term was changed, update the value
			if let newValue = term.newValue {
				for file in wself.selectedFiles.values {
					file.updateTerm(term.value, newValue: newValue)
				}
				wself.butSave?.isEnabled = true
			}
		}
		
		translationsTableDataSource?.translationDidChange = { [weak self] (translation: TranslationData) -> Void in
			
			guard let wself = self else {
				return
			}
			
			// A translation was changed, update the term object so it knows about the change
			if let selectedRow = wself.termsTableView?.selectedRow, selectedRow >= 0 {
				let termData = wself.termsTableDataSource?.data[selectedRow]
				wself.termsTableDataSource?.data[selectedRow].translationChanged = true
				
				// If there are changes in the translation
				if let newValue = translation.newValue {
					let file = wself.selectedFiles[translation.languageCode]
					file?.updateTranslationForTerm(termData!.value, newValue: newValue)
				}
				
				wself.termsTableView?.reloadData(forRowIndexes: IndexSet(integer: wself.termsTableView!.selectedRow),
					columnIndexes: IndexSet(integer: 0))
				
				wself.butSave?.isEnabled = true
			}
		}
        translationsTableDataSource?.translationDidBecomeFirstResponder = { (value: String) -> Void in
            
            let search = Search(files: self.selectedFiles)
            if let line: Line = search.lineMatchingTranslation(translation: value) {
                
                let displayedTerms: [TermData] = self.termsTableDataSource!.data
                var i = 0
                var found = false
                for term in displayedTerms {
                    if term.value == line.term {
                        found = true
                        break
                    }
                    i += 1
                }
                self.termsTableDataSource?.highlightedRow = i
                if !found {
                    self.termsTableDataSource?.data.append((value: line.term, newValue: nil, translationChanged: false) as TermData)
                }
                self.termsTableView?.reloadData()
//                let lastIndex = IndexSet([i])
//                self.termsTableView?.selectRowIndexes(lastIndex, byExtendingSelection: false)
            }
        }
    }
    
    func scanDirectoryForLocalizationFiles() {
        
        // Remove current files
        languagesPopup?.removeAllItems()
        files.removeAll()
        
        // Load new files
        let filesResult: FilesResult = SearchIOSLocalizations().searchInDirectory(url!)
        
        for (fileName, file) in filesResult {
            languagesPopup?.addItem(withTitle: fileName)
            for (countryCode, url) in file {
                loadLocalizationFile(url, countryCode: countryCode, fileName: fileName)
            }
        }
        showFirstFile()
	}
    
    func loadLocalizationFile (_ url: URL, countryCode: String, fileName: String) {
        
        var file: [String: LocalizationFile]? = files[fileName]
        if file == nil {
            file = [String: LocalizationFile]()
        }
		do {
			file![countryCode] = try IOSLocalizationFile(url: url)
            files[fileName] = file!
		}
		catch LocalizationFileError.fileNotFound(url) {
			RCLog("File not found \(url)")
		} catch {
			RCLog("Unknown error")
		}
    }
	
    func showFirstFile() {
        
        if let (fileName, _) = files.first {
            languagesPopup?.selectItem(withTitle: fileName)
            selectedFiles = files[fileName]!
            showBaseLanguage()
        }
    }
    
	func showBaseLanguage() {
		
		let baseLanguage = BaseLanguage(files: selectedFiles)
		var result = baseLanguage.get()
        if result.language == "" {
            if let (countryCode, file) = selectedFiles.first {
                result = (language: countryCode, terms: file.allTerms())
            }
        }
//		languagesPopup?.selectItem(withTitle: result.language)
		showTerms(result.terms)
	}
	
	func showTerms (_ terms: [String]) {
		
		clear()
		
		allTerms = [TermData]()
		for term in terms {
			allTerms.append((value: term, newValue: nil, translationChanged: false) as TermData)
		}
		
		termsTableDataSource?.data = allTerms
		termsTableView?.reloadData()
		updateAlerts("No selection")
	}
	
	func markFilesAsSaved() {
		for i in 0..<self.termsTableDataSource!.data.count {
			termsTableDataSource?.data[i].translationChanged = false
		}
		termsTableView?.reloadData()
    }
    
    func selectFileNamed (_ fileName: String) {
        
        selectedFiles = files[fileName]!
        showBaseLanguage()
    }
    
    func search (_ searchString: String) {
        
        termsTableView?.deselectRow(termsTableView!.selectedRow)
        
        let search = Search(files: selectedFiles)
        //
        termsTableDataSource?.data = search.searchInTerms(searchString)
        termsTableView?.reloadData()
        //
        translationsTableDataSource?.data = search.searchInTranslations(searchString)
        translationsTableView?.reloadData()
        
        // Add Placeholders if no matches found
        updateAlerts("No matches")
    }
}

extension AppViewController {
    
    fileprivate func clear() {
        termsTableView?.deselectRow(termsTableView!.selectedRow)
        translationsTableDataSource?.data = []
        translationsTableView?.reloadData()
    }
    
	fileprivate func createNewTerm() {
		let term = "term \(arc4random())"
        let line: Line = (term: term, translation: "", isComment: false)
		for (_, localizationFile) in selectedFiles {
			localizationFile.addLine(line)
		}
		// Insert it to the datasource
        let termData: TermData = (value: line.term, newValue: nil, translationChanged: false)
		termsTableDataSource?.data.append(termData)
		termsTableView?.beginUpdates()
		termsTableView?.insertRows(at: IndexSet(integer: termsTableDataSource!.data.count-1), withAnimation: .effectFade)
		termsTableView?.endUpdates()
	}
    
    fileprivate func removeTermAtIndex (row: Int) {
        let term: TermData = termsTableDataSource!.data[row]
        for (_, localizationFile) in selectedFiles {
            localizationFile.removeTerm(term)
        }
        // Remove from the datasource
        termsTableView?.beginUpdates()
        termsTableView?.removeRows(at: IndexSet(integer: row), withAnimation: .effectFade)
        termsTableView?.endUpdates()
        termsTableDataSource?.data.remove(at: row)
        
        butSave?.isEnabled = true
    }
}

extension AppViewController {
    
    @IBAction func fileNameDidChange (_ sender: NSPopUpButton) {
        
        selectedFiles = files[sender.titleOfSelectedItem!]!
        showBaseLanguage()
    }
    
//	@IBAction func languageDidChange (_ sender: NSPopUpButton) {
//        if let file = selectedFiles[sender.titleOfSelectedItem!] {
//            showTerms(file.allTerms())
//        }
//	}
    
	@IBAction func addButtonClicked (_ sender: NSButton) {
		createNewTerm()
	}
	
	@IBAction func removeButtonClicked (_ sender: NSButton) {
        if let index = termsTableView?.selectedRow {
            removeTermAtIndex(row: index)
        }
	}
}

extension AppViewController {
	
	fileprivate func updateAlerts (_ message: String) {
		translationsAlert(message).isHidden = translationsTableDataSource?.data.count > 0
		termsAlert(message).isHidden = termsTableDataSource?.data.count > 0
	}
	
	fileprivate func translationsAlert (_ message: String) -> InlinedAlertView {
		if translationsTableAlert == nil {
			translationsTableAlert = InlinedAlertView.instanceFromNib()
			translationsTableView?.addSubview(translationsTableAlert!)
			translationsTableAlert?.constrainToSuperview()
		}
		translationsTableAlert?.message = message
		return translationsTableAlert!
	}
	
	fileprivate func termsAlert (_ message: String) -> InlinedAlertView {
		if termsTableAlert == nil {
			termsTableAlert = InlinedAlertView.instanceFromNib()
			termsTableView?.addSubview(termsTableAlert!)
			termsTableAlert?.constrainToSuperview()
		}
		termsTableAlert?.message = message
		return termsTableAlert!
	}
}
