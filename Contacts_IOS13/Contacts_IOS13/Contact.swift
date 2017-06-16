//
//  Contact.swift
//  Contacts_IOS13
//
//  Created by Bradley GIlmore on 6/16/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import Foundation
import CloudKit

class Contact {
    
    //MARK: - Initializers
    
    init(name: String, phoneNumber: String = "", email: String = "", uuid: UUID = UUID()) { //FIXME: - Make sure this works with optionals
        
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.uuid = uuid
    }
    
    init?(record: CKRecord) {
        
        guard let name = record.value(forKey: kName) as? String,
            let phoneNumber = record.value(forKey: kPhone) as? String,
            let email = record.value(forKey: kEmail) as? String,
            let recordID = record.value(forKey: kRecordID) as? String,
            let recordUUID = UUID(uuidString: recordID) else {
                NSLog("Failed to initialize Contact from CKRecord")
                return nil
        }
        
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.uuid = recordUUID
    }
    
    //MARK: - Keys
    
    static let kRecordType = "contact"
    
    fileprivate let kName = "name"
    fileprivate let kPhone = "phone"
    fileprivate let kEmail = "email"
    fileprivate let kRecordID = "idOfRecord"
    
    //MARK: - Internal Properties
    
    // Initial Properties
    let name: String
    let phoneNumber: String
    let email: String
    
    // CKRecord ID
    let uuid: UUID
    var recordID: String {
        return uuid.uuidString
    }
    
    // CloudKitRecord
    var cloudKitRecord: CKRecord {
        
        // Gets the recordID that is in the UUID property, and attatches that to the new record being created.
        let recordID = CKRecordID.init(recordName: self.recordID) // Little side note here, why can't I just pass in the uuid?
        let record = CKRecord(recordType: Contact.kRecordType, recordID: recordID)
        
        record.setValue(name, forKey: kName)
        record.setValue(phoneNumber, forKey: kPhone)
        record.setValue(email, forKey: kEmail)
        record.setValue(self.recordID, forKey: kRecordID)
        
        return record
    }
}
