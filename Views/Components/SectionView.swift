import SwiftUI

struct SectionView<Content: View>: View {
    var title: String
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment:.leading, spacing:8) {
            Text(title).font(.headline)
            content()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color:Color.black.opacity(0.05), radius:2)
    }
}
