import SwiftUI
import Foundation
import Contacts

struct NewChatView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var contacts: [CNContact] = []
    @State private var isLoading = true
    @State private var selectedContact: String? // To store selected contact
    @State private var navigateToChat = false  // Control navigation

    let contactsManager = ContactsManager()

    var body: some View {
        NavigationView {
            VStack {
                // Search field
                TextField("Search contact", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // List of contacts
                List(filteredContacts, id: \.identifier) { contact in
                    Button(action: {
                        // Select contact and trigger navigation
                        selectedContact = contact.givenName + "  " + contact.familyName
                        navigateToChat = true
                    }) {
                        HStack {
                            Text(contact.givenName + " " + contact.familyName)
                            Spacer()
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .overlay {
                    if isLoading {
                        ProgressView("Loading contacts...")
                    }
                }
            }
            .navigationTitle("New Message")
            .onAppear {
                loadContacts()
            }
            .background(
                // Hidden NavigationLink for navigation
                NavigationLink(
                    destination: ChatView(
                        messages: .constant([]), // Pass an empty array initially
                        chatName: selectedContact ?? "Chat"
                    ),
                    isActive: $navigateToChat
                ) { EmptyView() }
            )
        }
    }

    // MARK: - Load Contacts
    private func loadContacts() {
        contactsManager.requestAccess { granted in
            DispatchQueue.main.async {
                if granted {
                    self.contacts = contactsManager.fetchContacts() // Fetch and assign contacts
                }
                isLoading = false
            }
        }
    }

    // MARK: - Filter Contacts
    private var filteredContacts: [CNContact] {
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter {
                $0.givenName.localizedCaseInsensitiveContains(searchText) ||
                $0.familyName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}


struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewChatView()
        }
    }
}
