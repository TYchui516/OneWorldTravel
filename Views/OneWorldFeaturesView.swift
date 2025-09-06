import SwiftUI

struct OneWorldFeaturesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing:15) {
                SectionView(title: "🌐 全球功能") {
                    VStack(alignment:.leading, spacing:8) {
                        Text("👥 即時多語會議模式 (N人多語)")
                        Text("💬 全球聊天室/語言交換")
                        Text("🈺 文化模式 (翻譯 + 背景解釋)")
                        Text("📱 翻譯名片 QR Code")
                        Text("📦 One World 離線地球")
                    }
                }
            }
            .padding()
        }
    }
}
