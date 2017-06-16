//
//  ContactDetailViewController.swift
//  Contacts_IOS13
//
//  Created by Bradley GIlmore on 6/16/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import UIKit
import CloudKit

class ContactDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkContact()
    }
    
    func checkContact() {
        
        guard let contact = contact else { titleBar.title = "Add Contact"; return }
        
        nameTextField.text = contact.name
        phoneTextField.text = contact.phoneNumber
        emailTextField.text = contact.email
        titleBar.title = "Edit Contact"
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if !isEditingContact {
            
            guard let name = nameTextField.text,
                let email = emailTextField.text,
                let phone = phoneTextField.text else { return }
            
            ContactController.createContactWith(name: name, phoneNumber: phone, email: email)
            navigationController?.popViewController(animated: true)
        }
        
        if isEditingContact {
            
            guard let contact = contact,
                let index = index,
                let name = nameTextField.text, nameTextField.text != "",
                let phone = phoneTextField.text,
                let email = emailTextField.text else { return } //FIXME: - May have to check if they are all empty
            
            let newContact = Contact(name: name, phoneNumber: phone, email: email)
            
            let modifiedRecordID = CKRecordID.init(recordName: contact.recordID)
            
            CloudKitManager.modifyCurrentRecords(record: newContact.cloudKitRecord, recordID: modifiedRecordID)
            
            ContactController.contacts.remove(at: index)
            ContactController.contacts.insert(newContact, at: index)
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var titleBar: UINavigationItem!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    //MARK: - Properties
    
    var contact: Contact?
    var isEditingContact: Bool = false
    var index: Int?
}
