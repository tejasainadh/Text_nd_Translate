import SwiftUI
import Foundation

struct ChatsListView: View {
    @State private var isShowingNewChatView = false
    @State private var sampleChats = [
        ChatOverview(contactNameOrNumber: "Giulia", lastMessage: "Ciao!"),
        ChatOverview(contactNameOrNumber: "Mario Rossi", lastMessage: "See you later!"),
        ChatOverview(contactNameOrNumber: "+39 345 678 9012", lastMessage: "Hello! How are you?")
    ]
    
    @State private var messagesDictionary: [String: [ChatMessage]] = [
        "Giulia": [ChatMessage(content: "Hola, ¿cómo estás?", translatedContent: "Hello, how are you?", sender: "User", recipient: "Giulia", timestamp: Date(), isIncoming: true)],
        "Mario Rossi": [ChatMessage(content: "Hello!", translatedContent: "Hello!", sender: "User", recipient: "Mario Rossi", timestamp: Date(), isIncoming: false)],
        "+39 345 678 9012": [ChatMessage(content: "Hi!", translatedContent: "Hi!", sender: "User", recipient: "+39 345 678 9012", timestamp: Date(), isIncoming: true)]
    ]


    var body: some View {
        NavigationView {
            VStack {
                List(sampleChats) { chat in
                    if let messages = messagesDictionary[chat.contactNameOrNumber] {
                        // Pass Binding to ChatView by creating a Binding to the specific array of messages
                        NavigationLink(destination: ChatView(messages: Binding(
                            get: { self.messagesDictionary[chat.contactNameOrNumber] ?? [] },
                            set: { self.messagesDictionary[chat.contactNameOrNumber] = $0 }
                        ), chatName: chat.contactNameOrNumber)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(chat.contactNameOrNumber)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text(chat.lastMessage)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    } else {
                        // Handle case where messages do not exist (e.g., for new chats)
                        Text("No messages")
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Messages")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingNewChatView = true
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $isShowingNewChatView) {
                NewChatView()
            }
        }
    }
}

struct ChatsListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsListView()
    }
}
