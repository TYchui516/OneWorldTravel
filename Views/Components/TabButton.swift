import SwiftUI

struct TabButton: View {
    var title:String
    var index:Int
    @Binding var selected:Int
    
    var body: some View {
        Button(action:{ selected = index }) {
            VStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(selected == index ? .blue : .gray)
            }
            .frame(maxWidth:.infinity)
        }
    }
}
