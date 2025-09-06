import Foundation

enum ConfigManager {
    static func get(_ key: String) -> String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let value = dict[key] as? String else {
            fatalError("❌ 沒有找到 \(key)，請檢查 Config.plist")
        }
        return value
    }
}
