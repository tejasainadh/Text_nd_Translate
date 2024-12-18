import Foundation
import Contacts

class ContactsManager {
    func requestAccess(completion: @escaping (Bool) -> Void) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            if let error = error {
                print("Error accessing contacts: \(error.localizedDescription)")
            }
            completion(granted)
        }
    }

    func fetchContacts() -> [CNContact] {
        let store = CNContactStore()
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactIdentifierKey] as [CNKeyDescriptor]
        var contacts: [CNContact] = []

        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        do {
            try store.enumerateContacts(with: request) { contact, _ in
                contacts.append(contact)
            }
        } catch {
            print("Failed to fetch contacts: \(error.localizedDescription)")
        }
        return contacts
    }
}
