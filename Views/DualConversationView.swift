import SwiftUI

struct DualConversationView: View {
    @StateObject private var vm = SpeechViewModel()

    var body: some View {
        VStack {
            ScrollView {
                ForEach(vm.messages) { msg in
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(msg.speaker)：\(msg.original)").bold()
                        Text("翻譯：\(msg.translated)")
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    .padding()
                }
            }

            if let error = vm.errorMessage {
                Text("⚠️ \(error)").foregroundColor(.red)
            }

            HStack {
                Button(vm.isListening ? "停止" : "開始") {
                    if vm.isListening {
                        vm.stopListening()
                    } else {
                        vm.startListening()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(vm.isListening ? Color.red : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                Button("切換說話者") {
                    vm.activeSpeaker = (vm.activeSpeaker == "User A") ? "User B" : "User A"
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    DualConversationView()
}
