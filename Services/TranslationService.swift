import Foundation

class TranslationService {
    private let apiKey = ConfigManager.get("OPENAI_API_KEY")
    private let endpoint = URL(string: "https://api.openai.com/v1/chat/completions")!

    /// 使用 OpenAI GPT API 翻譯文字
    func translate(text: String, targetLang: String = "English") async throws -> String {
        // ✅ 建立請求
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        // ✅ 設定請求 Body
        let body: [String: Any] = [
            "model": "gpt-4o-mini",  // 輕量快速模型
            "messages": [
                ["role": "system", "content": "You are a helpful translation assistant."],
                ["role": "user", "content": "Translate into \(targetLang): \(text)"]
            ]
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        // ✅ 傳送請求
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "TranslationService", code: -1, userInfo: [NSLocalizedDescriptionKey: "無效的伺服器回應"])
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let err = String(data: data, encoding: .utf8) ?? "未知錯誤"
            throw NSError(domain: "TranslationService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: err])
        }

        // ✅ 解析 JSON 回應
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        if let choices = json?["choices"] as? [[String: Any]],
           let message = choices.first?["message"] as? [String: Any],
           let content = message["content"] as? String {
            return content.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        return "⚠️ 無法取得翻譯結果"
    }
}
