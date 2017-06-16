//
//  CloudKitManager.swift
//  Contacts_IOS13
//
//  Created by Bradley GIlmore on 6/16/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    // Modify
    static func modifyCurrentRecords(record: CKRecord, recordID: CKRecordID) {
        
        // Create initial operation
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: [recordID])
        
        // Make it so it only saves over things that are different, and it will perform quickly
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.queuePriority = .high
        
        // Add operation to operations queue
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    // Delete
    static func deleteRecords(RecordID: CKRecordID, completion: ((_ recordID: CKRecordID?, _ error: Error?) -> Void)?) {
        
        CKContainer.default().publicCloudDatabase.delete(withRecordID: RecordID) { (RecordID, error) in
            
            if let error = error {
                NSLog("Error deleting CloudKit with RecordID \(error.localizedDescription)")
            } //FIXME: - Delete this later.
            completion?(RecordID, error)
        }
        
    }
    
    // Subscribe
    static func subscribeToNotifications(recordType: String) { // Contact.kRecordType
        
        let predicate = NSPredicate(value: true)
        
        let subsciption = CKQuerySubscription(recordType: recordType, predicate: predicate, options: .firesOnRecordCreation)
        
        // Create Notification Info
        let notificationInfo = CKNotificationInfo()
        
        // Set its properties
        notificationInfo.alertBody = "There has been a new contact added to your contact list"
        notificationInfo.soundName = "default"
        notificationInfo.shouldSendContentAvailable = true
        
        // Add to the subscription
        subsciption.notificationInfo = notificationInfo
        
        CKContainer.default().publicCloudDatabase.save(subsciption) { (_, error) in
            if let error = error { NSLog("Error saving subscription to CloudKit \(error.localizedDescription)") }
        }
        
    }
}
