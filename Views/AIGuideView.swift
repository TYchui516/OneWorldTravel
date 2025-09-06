import SwiftUI

struct AIGuideView: View {
    var body: some View {
        ScrollView {
            SectionView(title: "📍 你現在的位置：台北101") {
                Text("推薦行程：下午去象山看夜景 → 晚餐在信義區 🍣")
                Text("小提示：週末人潮較多，建議搭捷運 🚇")
            }
            SectionView(title: "導遊解說") {
                Text("台北101 高度508公尺，是台灣象徵之一...")
            }
        }
        .padding()
    }
}
