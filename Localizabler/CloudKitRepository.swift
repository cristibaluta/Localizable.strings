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
    
    static let shared = CloudKitRepository()
    
    internal let publicDB = CKContainer.default().publicCloudDatabase
    fileprivate var userRecord: CKRecord?
    
    init() {
//        CKContainer.default().accountStatus(completionHandler: { (status, error) in
//            RCLog(status.rawValue)
//            RCLogErrorO(error)
//            if let error = error {
//                // some error occurred (probably a failed connection, try again)
//            } else {
//                switch status {
//                case .available: break
//                // the user is logged in
//                case .noAccount: break
//                // the user is NOT logged in
//                case .couldNotDetermine: break
//                // for some reason, the status could not be determined (try again)
//                case .restricted: break
//                    // iCloud settings are restricted by parental controls or a configuration profile
//                }
//            }
//        })
        
//        readAllSubmittedTerms()
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
        
//        CKRecordID *artistRecordID = [[CKRecordID alloc] initWithRecordName:@"Mei Chen"];
//        CKReference *artistReference = [[CKReference alloc] initWithRecordID:artistRecordID action:CKReferenceActionNone];
        
        let record = CKRecord(recordType: "Translation")
        record["term"] = term.value as CKRecordValue
        record["translation"] = translation.newValue! as CKRecordValue
        record["language"] = translation.languageCode as CKRecordValue
        
        publicDB.save(record) { (savedRecord, err) in
            RCLogO(savedRecord)
            RCLogErrorO(err)
        }
    }
    
    func getUser (_ completion: @escaping ((User?) -> Void)) {
        
        if let record = self.userRecord {
            completion( userFromRecord(record) )
        } else {
            CKContainer.default().fetchUserRecordID { recordID, error in
                guard let recordID = recordID, error == nil else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                self.publicDB.fetch(withRecordID: recordID) { record, error in
                    guard let record = record, error == nil else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        return
                    }
                    self.userRecord = record
                    DispatchQueue.main.async {
                        completion( self.userFromRecord(record) )
                    }
                }
            }
        }
    }
    
    fileprivate func userFromRecord (_ record: CKRecord) -> User {
        return User(name: record["name"] as! String, languageCode: record["nativeLanguage"] as! String)
    }
    
    func updateUser (name: String, languageCode: String) {
        
        getUser { user in
            
            guard let record = self.userRecord else {
                return
            }
            record["name"] = name as CKRecordValue
            record["nativeLanguage"] = languageCode as CKRecordValue
            
            CKContainer.default().publicCloudDatabase.save(self.userRecord!) { _, error in
                guard error == nil else {
                    // top-notch error handling
                    return
                }
                
                print("Successfully updated user record")
            }
        }
    }
}
