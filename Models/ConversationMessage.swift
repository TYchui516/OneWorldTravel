import Foundation

struct ConversationMessage: Identifiable {
    let id = UUID()
    let speaker: String   // "User A" or "User B"
    let original: String
    let translated: String
}
