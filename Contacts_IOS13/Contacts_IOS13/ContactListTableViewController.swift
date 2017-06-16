//
//  ContactListTableViewController.swift
//  Contacts_IOS13
//
//  Created by Bradley GIlmore on 6/16/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import UIKit
import CloudKit

class ContactListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: ContactController.contactsUpdatedNotification, object: nil)
        
        // Initial Fetch
        ContactController.fetchNewContacts()
    }
    
    func refresh() {
        tableView.reloadData()
    }
    
    //MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        let contact = ContactController.contacts[indexPath.row]
        
        cell.textLabel?.text = contact.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let contact = ContactController.contacts[indexPath.row]
            let recordID = CKRecordID.init(recordName: contact.recordID)
            
            CloudKitManager.deleteRecords(RecordID: recordID, completion: { (_, error) in
                
                if let error = error {
                    NSLog("Error deleting data \(error.localizedDescription)")
                    return
                }
            })
            
            ContactController.contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editContactSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let detailViewController = segue.destination as? ContactDetailViewController else {
                    NSLog("editContactSegue Error")
                    return
            }
            
            let contact = ContactController.contacts[indexPath.row]

            detailViewController.contact = contact
            detailViewController.isEditingContact = true
            detailViewController.index = indexPath.row
        }
    }
}
