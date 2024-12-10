import SwiftUI

struct ChatView: View {
    let chatName: String // The name of the person you're chatting with
    @State private var messages: [ChatMessage] = [
        ChatMessage(content: "Ciao!", translatedContent: "Hello!", isIncoming: true, timestamp: Date()),
        ChatMessage(content: "Come stai?", translatedContent: "How are you?", isIncoming: true, timestamp: Date())
    ]
    @State private var newMessage: String = ""

    var body: some View {
        VStack {
            // Message List
            List(messages) { message in
                HStack {
                    if message.isIncoming {
                        VStack(alignment: .leading) {
                            Text(message.content)
                                .padding(10)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(.black)

                            Text(message.translatedContent)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.top, 2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        VStack(alignment: .trailing) {
                            Text(message.content)
                                .padding(10)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundColor(.white)

                            Text(message.translatedContent)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.top, 2)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
            
            // Input Field and Send Button
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 10)

                Button(action: {
                    sendMessage()
                }) {
                    Image(systemName: "arrow.up.circle.fill") // Arrow-in-circle icon
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
                .padding(.trailing, 10)
                .accessibilityLabel("Send message")
            }
            .padding()
        }
        .navigationTitle(chatName)
        .navigationBarTitleDisplayMode(.inline)
    }

    // Function to send a message
    func sendMessage() {
        guard !newMessage.isEmpty else { return }

        let translatedMessage = translateToItalian(newMessage) // Translate the message
        let outgoingMessage = ChatMessage(
            content: newMessage,
            translatedContent: translatedMessage,
            isIncoming: false,
            timestamp: Date()
        )
        messages.append(outgoingMessage) // Add the new message to the list
        newMessage = "" // Clear the input field
    }

    // Function to translate text into Italian
    func translateToItalian(_ text: String) -> String {
        let translations = [
            "Hello!": "Ciao!",
            "How are you?": "Come stai?",
            "I'm good, thank you!": "Sto bene, grazie!",
            "What are you doing?": "Cosa stai facendo?",
            "See you later!": "A dopo!"
        ]
        return translations[text] ?? "Translation not found"
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chatName: "Alice")
    }
}
