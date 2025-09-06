import SwiftUI

struct OneWorldAppView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing:0) {
            if selectedTab == 0 {
                ContentView()
            } else if selectedTab == 1 {
                DualConversationView()
            } else if selectedTab == 2 {
                AIGuideView()
            } else if selectedTab == 3 {
                OneWorldFeaturesView()
            } else {
                SettingsView()
            }
            
            Divider()
            HStack {
                TabButton(title: "翻譯", index: 0, selected: $selectedTab)
                TabButton(title: "對話", index: 1, selected: $selectedTab)
                TabButton(title: "導遊", index: 2, selected: $selectedTab)
                TabButton(title: "全球", index: 3, selected: $selectedTab)
                TabButton(title: "設定", index: 4, selected: $selectedTab)
            }
            .padding(.bottom, 8)
            .background(Color(.systemGray5))
        }
    }
}
