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
    
    func readMySubmittedTerms(_ completion: @escaping (([RequestTerm]?) -> Void)) {
        
        getUser { (user) in
            
            guard let userId = self.userRecord?.recordID else {
                return
            }
            let predicate = NSPredicate(format: "creatorUserRecordID == %@", userId)
            let query = CKQuery(recordType: "Term", predicate: predicate)
            
            self.publicDB.perform(query, inZoneWith: nil) { (records, err) in
                RCLogO(records)
                RCLogErrorO(err)
                if let records = records {
                    var terms = [RequestTerm]()
                    for record in records {
                        terms.append( RequestTerm(key: record["key"] as! String, value: record["englishValue"] as! String) )
                    }
                    DispatchQueue.main.async {
                        completion(terms)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func readAllSubmittedTerms(_ completion: @escaping (([RequestTerm]?) -> Void)) {
        
        getUser { (user) in
            
            guard let userId = self.userRecord?.recordID else {
                return
            }
            let predicate = NSPredicate(format: "creatorUserRecordID != %@", userId)
            let query = CKQuery(recordType: "Term", predicate: predicate)
            
            self.publicDB.perform(query, inZoneWith: nil) { (records, err) in
                RCLogO(records)
                RCLogErrorO(err)
                if let records = records {
                    var terms = [RequestTerm]()
                    for record in records {
                        terms.append( RequestTerm(key: record["key"] as! String, value: record["englishValue"] as! String) )
                    }
                    DispatchQueue.main.async {
                        completion(terms)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func write (terms: [RequestTerm]) {
        var i = 0
        var records = [CKRecord]()
        for term in terms {
            let record = CKRecord(recordType: "Term")
            record["key"] = term.key as CKRecordValue
            record["englishValue"] = term.value as CKRecordValue
            records.append(record)
            i += 1
            if i > 10 {
                break
            }
        }
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.modifyRecordsCompletionBlock = { (saved, deleted, error) in
            RCLogErrorO(error)
        }
        publicDB.add(operation)
    }
    
    func write (translation: Translation, forTerm term: RequestTerm) {
        
//        CKRecordID *artistRecordID = [[CKRecordID alloc] initWithRecordName:@"Mei Chen"];
//        CKReference *artistReference = [[CKReference alloc] initWithRecordID:artistRecordID action:CKReferenceActionNone];
        
        let record = CKRecord(recordType: "Translation")
        record["term"] = term.key as CKRecordValue
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
