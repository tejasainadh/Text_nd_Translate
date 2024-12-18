//
//  CheckRegisteredUsers.swift
//  Translate
//
//  Created by Tejsainadh on 12/12/24.
//

import Foundation
import FirebaseFirestore
import Contacts

func checkRegisteredUsers(contacts: [CNContact], completion: @escaping ([CNContact]) -> Void) {
    let db = Firestore.firestore()
    var registeredContacts: [CNContact] = []
    
    for contact in contacts {
        for phoneNumber in contact.phoneNumbers {
            let number = phoneNumber.value.stringValue
            let formattedNumber = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) // Format number
            
            // Query Firestore for matching user
            db.collection("users").whereField("phoneNumber", isEqualTo: formattedNumber).getDocuments { snapshot, error in
                if let error = error {
                    print("Failed to query Firestore: \(error)")
                    return
                }
                
                // Check if documents are found
                if let snapshot = snapshot, snapshot.documents.isEmpty == false {
                    // Append the contact to the registeredContacts array
                    registeredContacts.append(contact)
                }
                
                // Ensure we call the completion handler only after processing all contacts
                if contacts.last == contact {
                    // All contacts are processed, so call completion now
                    completion(registeredContacts)
                }
            }
        }
    }
}
