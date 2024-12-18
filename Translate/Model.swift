import Foundation

struct ChatMessage: Identifiable {
    var id: String = UUID().uuidString
    var content: String
    var translatedContent: String?  // This will hold the translated text
    var sender: String
    var recipient: String
    var timestamp: Date
    var isIncoming: Bool // This tracks whether the message is incoming or outgoing
    
    // Custom initializer to set all properties
    init(content: String, translatedContent: String? = nil, sender: String, recipient: String, timestamp: Date, isIncoming: Bool) {
        self.content = content
        self.translatedContent = translatedContent
        self.sender = sender
        self.recipient = recipient
        self.timestamp = timestamp
        self.isIncoming = isIncoming
    }
}
