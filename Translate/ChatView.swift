import SwiftUI
import Foundation

struct ChatView: View {
    @Binding var messages: [ChatMessage]
    @State private var newMessage: String = ""
    @State private var selectedLanguage: String = "en" // Default language for translation
    var chatName: String // Add the chat name variable
    
    let api = YandexTranslateAPI()
    
    // List of supported languages
    let supportedLanguages = [
        "English": "en",
        "Spanish": "es",
        "French": "fr",
        "German": "de",
        "Italian": "it",
        "Russian": "ru"
    ]
    
    var body: some View {
        VStack {
            // Language Picker at the Top
            HStack {
                Text("Translate to:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Picker("Select Language", selection: $selectedLanguage) {
                    ForEach(supportedLanguages.sorted(by: <), id: \.key) { languageName, code in
                        Text(languageName).tag(code)
                    }
                }
                .pickerStyle(MenuPickerStyle()) // Dropdown style picker
                .onChange(of: selectedLanguage) { _ in
                    translateAllMessages()
                }
            }
            .padding()
            
            // Messages List
            List(messages) { message in
                HStack {
                    if message.isIncoming {
                        // Incoming Message
                        VStack(alignment: .leading) {
                            Text(message.content)
                                .padding(10)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                            
                            if let translated = message.translatedContent {
                                Text(translated)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.top, 2)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        // Outgoing Message
                        VStack(alignment: .trailing) {
                            Text(message.content)
                                .padding(10)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                            
                            if let translated = message.translatedContent {
                                Text(translated)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.top, 2)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
            
            // Input Field for New Messages
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 10)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
                .padding(.trailing, 10)
            }
            .padding()
        }
        .navigationTitle(chatName) // Display the chat name
        .onAppear {
            translateAllMessages() // Ensure messages are translated when view loads
        }
    }
    
    // MARK: - Translate All Incoming Messages
    private func translateAllMessages() {
        for (index, message) in messages.enumerated() where message.isIncoming {
            api.translate(text: message.content, to: selectedLanguage) { translation in
                DispatchQueue.main.async {
                    if let translation = translation, !translation.isEmpty {
                        messages[index].translatedContent = translation
                    } else {
                        messages[index].translatedContent = "Translation failed"
                    }
                }
            }
        }
    }
    
    // MARK: - Send New Message
    func sendMessage() {
        guard !newMessage.isEmpty else { return }
        
        // Create a new ChatMessage object
        let outgoingMessage = ChatMessage(
            content: newMessage,
            sender: "currentUserID", // Replace with actual sender ID
            recipient: chatName,     // Use the contact name as the recipient
            timestamp: Date(),
            isIncoming: false       // Outgoing message
        )
        
        // Append the message locally to update the UI
        messages.append(outgoingMessage)
        
        // Clear the input field
        let messageToTranslate = newMessage
        newMessage = ""
        
        // Send the message to Firestore
        let chatService = ChatService()
        chatService.sendMessage(to: chatName, message: outgoingMessage)
        
        // Optionally translate the message
        api.translate(text: messageToTranslate, to: selectedLanguage) { translation in
            DispatchQueue.main.async {
                if let index = messages.firstIndex(where: { $0.content == messageToTranslate }) {
                    if let translation = translation, !translation.isEmpty {
                        messages[index].translatedContent = translation
                    } else {
                        messages[index].translatedContent = "Translation failed"
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct ChatView_Previews: PreviewProvider {
    @State static var sampleMessages = [
        ChatMessage(content: "Hola, ¿cómo estás?", translatedContent: "Hello, how are you?", sender: "Giulia", recipient: "User", timestamp: Date(), isIncoming: true),
        ChatMessage(content: "Bonjour, ça va?", translatedContent: "Hello, how's it going?", sender: "Giulia", recipient: "User", timestamp: Date(), isIncoming: true),
        ChatMessage(content: "Hello!", translatedContent: "Hello!", sender: "User", recipient: "Giulia", timestamp: Date(), isIncoming: false)
    ]
    
    static var previews: some View {
        NavigationView {
            // Pass the @State variable as a Binding to the ChatView
            ChatView(messages: $sampleMessages, chatName: "Giulia")
        }
    }
}
