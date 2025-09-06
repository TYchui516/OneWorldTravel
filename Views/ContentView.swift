import SwiftUI

struct ContentView: View {
    let scenes = ["🛒 購物", "🍽 餐廳", "🏨 住宿", "🚕 交通", "🎫 景點"]
    @State private var favorites: [String] = ["多少錢？", "廁所在哪裡？"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                SectionView(title: "場景模式") {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 12) {
                        ForEach(scenes, id: \.self) { scene in
                            Button(scene) { print("👉 選擇場景 \(scene)") }
                                .padding()
                                .frame(maxWidth:.infinity)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                    }
                }
                
                SectionView(title: "收藏 & 離線詞庫") {
                    ForEach(favorites, id: \.self) { fav in
                        HStack {
                            Text(fav)
                            Spacer()
                            Button("⭐️") {}
                        }
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
    }
}
