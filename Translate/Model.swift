
import SwiftUI

// Model for a chat message
struct ChatMessage: Identifiable {
    let id: UUID
    let content: String
    let translatedContent: String
    let isIncoming: Bool
    let timestamp: Date

    // Custom initializer for easier creation of chat messages
    init(content: String, translatedContent: String, isIncoming: Bool, timestamp: Date) {
        self.id = UUID()
        self.content = content
        self.translatedContent = translatedContent
        self.isIncoming = isIncoming
        self.timestamp = timestamp
    }
}
