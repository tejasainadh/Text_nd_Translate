import Foundation
import FirebaseFirestore

class ChatService {
    private let db = Firestore.firestore()
    private let currentUser = "User" // Replace this with the logged-in user's identifier
    private let yandexTranslateAPI = YandexTranslateAPI() // Create an instance of YandexTranslateAPI
    
    // MARK: - Send Message
    func sendMessage(to chatId: String, message: ChatMessage, recipientPreferredLanguage: String? = nil) {
        // If a recipient's preferred language is provided, translate the message before sending
        var translatedMessage = message.content
        
        if let preferredLanguage = recipientPreferredLanguage {
            // Translate the message using the translation API
            translateMessage(message.content, to: preferredLanguage) { translatedText in
                // Use the translated message if it's available
                if let translatedText = translatedText {
                    translatedMessage = translatedText
                }
                
                // Send the message with the translated content
                let messageData: [String: Any] = [
                    "content": message.content,
                    "translatedContent": translatedMessage, // Store the translated content
                    "sender": message.sender,
                    "recipient": message.recipient,
                    "timestamp": message.timestamp
                ]
                
                self.db.collection("chats")
                    .document(chatId)
                    .collection("messages")
                    .addDocument(data: messageData) { error in
                        if let error = error {
                            print("Error sending message: \(error.localizedDescription)")
                        } else {
                            print("Message sent successfully.")
                        }
                    }
            }
        } else {
            // If no translation is needed, just send the message
            let messageData: [String: Any] = [
                "content": message.content,
                "translatedContent": "", // No translation for now
                "sender": message.sender,
                "recipient": message.recipient,
                "timestamp": message.timestamp
            ]
            
            self.db.collection("chats")
                .document(chatId)
                .collection("messages")
                .addDocument(data: messageData) { error in
                    if let error = error {
                        print("Error sending message: \(error.localizedDescription)")
                    } else {
                        print("Message sent successfully.")
                    }
                }
        }
    }
    
    // MARK: - Fetch Messages
    // MARK: - Fetch Messages
    func fetchMessages(for chatId: String, recipientPreferredLanguage: String? = nil, completion: @escaping ([ChatMessage]) -> Void) {
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error.localizedDescription)")
                    return
                }
                
                var messages: [ChatMessage] = []
                
                let dispatchGroup = DispatchGroup() // To wait for all translations to finish
                
                snapshot?.documents.forEach { doc in
                    let data = doc.data()
                    
                    // Parse Firestore data
                    guard let content = data["content"] as? String,
                          let sender = data["sender"] as? String,
                          let recipient = data["recipient"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else {
                        return
                    }
                    
                    var translatedContent: String? = data["translatedContent"] as? String
                    
                    // If the recipient has a preferred language, fetch the translation
                    if let recipientPreferredLanguage = recipientPreferredLanguage, translatedContent == nil {
                        dispatchGroup.enter()
                        self.translateMessage(content, to: recipientPreferredLanguage) { translation in
                            translatedContent = translation
                            dispatchGroup.leave()
                        }
                    }
                    
                    // Add the message to the list (we'll update it later after translations)
                    let message = ChatMessage(
                        content: content,
                        translatedContent: translatedContent,
                        sender: sender,
                        recipient: recipient,
                        timestamp: timestamp.dateValue(),
                        isIncoming: true // or false depending on your logic
                    )

                    
                    
                    messages.append(message)
                }
                
                // Wait for all translations to finish
                dispatchGroup.notify(queue: .main) {
                    completion(messages)
                }
            }
    }

    // MARK: - Translation Logic with Yandex API
    private func translateMessage(_ messageContent: String, to languageCode: String, completion: @escaping (String?) -> Void) {
        // Use the YandexTranslateAPI to translate the message
        yandexTranslateAPI.translate(text: messageContent, to: languageCode) { translatedText in
            if let translatedText = translatedText {
                completion(translatedText)
            } else {
                print("Translation failed")
                completion(nil)
            }
        }
    }
}
