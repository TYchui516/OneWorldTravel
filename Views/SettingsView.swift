import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("⚙️ 設定")
            Toggle("使用 OpenAI 翻譯", isOn:.constant(true))
            Button("清空紀錄"){}
            Spacer()
        }
        .padding()
    }
}
