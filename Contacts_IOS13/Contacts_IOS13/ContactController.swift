//
//  ContactController.swift
//  Contacts_IOS13
//
//  Created by Bradley GIlmore on 6/16/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import Foundation
import CloudKit

class ContactController {
    
    //MARK: - CloudKitFunctions / CRUD
    
    // Fetch Contacts
    static func fetchNewContacts() {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: Contact.kRecordType, predicate: predicate)
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error { NSLog("Failed fetching new contacts \(error.localizedDescription)") }
            
            guard let records = records else { return }
            
            let contacts = records.flatMap { Contact(record: $0) }
            self.contacts = contacts
        }
    }
    
    // Create Contact
    static func createContactWith(name: String, phoneNumber: String, email: String) {
        
        let contact = Contact(name: name, phoneNumber: phoneNumber, email: email)
        
        CKContainer.default().publicCloudDatabase.save(contact.cloudKitRecord) { (record, error) in
            
            if let error = error { NSLog("Error creating contact. \(error.localizedDescription)") }
            
            self.contacts.append(contact)
        }
    }
    
    //MARK: - Notifications
    
    static let contactsUpdatedNotification = Notification.Name("ContactsUpdated")
    
    //MARK: - Internal Properties
    
    static var contacts: [Contact] = [] {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: contactsUpdatedNotification, object: self)
            }
        }
    }
}
