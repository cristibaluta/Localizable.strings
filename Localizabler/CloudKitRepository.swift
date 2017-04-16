//
//  CloudKitRepository.swift
//  Localizable.strings
//
//  Created by Cristian Baluta on 16/04/2017.
//  Copyright © 2017 Cristian Baluta. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitRepository {
    
    internal let publicDB = CKContainer.default().publicCloudDatabase
    
    init() {
//        CKContainer.default().accountStatus(completionHandler: { (status, error) in
//            RCLog(status.rawValue)
//            RCLogErrorO(error)
//        })
        
        
        readAllSubmittedTerms()
//        write(term: (value: "Hello", newValue: nil, translationChanged: false), desiredLanguages: ["ro", "fi", "jp"])
    }
    
    func readMySubmittedTerms() {
        
        CKContainer.default().fetchUserRecordID { (userRecordID, err) in
            
            RCLogO(userRecordID)
            
            guard let userId = userRecordID else {
                return
            }
            let predicate = NSPredicate(format: "creatorUserRecordID == %@", userId)
            let query = CKQuery(recordType: "Term", predicate: predicate)
            
            self.publicDB.perform(query, inZoneWith: nil) { (records, err) in
                RCLogO(records)
                RCLogErrorO(err)
            }
        }
    }
    
    func readAllSubmittedTerms() {
        
        CKContainer.default().fetchUserRecordID { (userRecordID, err) in
            
            RCLogO(userRecordID)
            
            guard let userId = userRecordID else {
                return
            }
            let predicate = NSPredicate(format: "creatorUserRecordID != %@", userId)
            let query = CKQuery(recordType: "Term", predicate: predicate)
            
            self.publicDB.perform(query, inZoneWith: nil) { (records, err) in
                RCLogO(records)
                RCLogErrorO(err)
            }
        }
    }
    
    func write (term: TermData, desiredLanguages: [String]) {
        
        let record = CKRecord(recordType: "Term")
        record["term"] = term.value as CKRecordValue
        record["desiredLanguages"] = desiredLanguages as CKRecordValue
        
        publicDB.save(record) { (savedRecord, err) in
            RCLogO(savedRecord)
            RCLogErrorO(err)
        }
    }
    
    func write (translation: TranslationData, forTerm term: TermData) {
        
        let record = CKRecord(recordType: "Translation")
        record["term"] = term.value as CKRecordValue
        record["translation"] = translation.newValue! as CKRecordValue
        record["language"] = translation.languageCode as CKRecordValue
        
        publicDB.save(record) { (savedRecord, err) in
            RCLogO(savedRecord)
            RCLogErrorO(err)
        }
    }
}
