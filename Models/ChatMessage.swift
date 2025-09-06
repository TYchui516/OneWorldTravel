import Foundation

struct ChatMessage: Identifiable {
    var id = UUID()
    var isUser: Bool
    var text: String
    var isTranslation: Bool
    var timestamp: Date
}
