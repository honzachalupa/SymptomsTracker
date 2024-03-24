import SwiftUI
import SwiftData
import MCEmojiPicker

struct TriggerCreateScreen: View {
    @Environment(\.dismiss) var dismiss
    @State var dataStore = DataStoreManager()
    @State private var name: String = ""
    @State private var icon: String = ""
    @State private var isEmojiSelectorShown: Bool = false
    
    private func create() {
        Task {
            await dataStore.create(
                Trigger(
                    name: name,
                    icon: icon
                )
            )
        }
    }
    
    var body: some View {
        List {
            HStack {
                Button(icon.count > 0 ? icon : "❓") {
                    isEmojiSelectorShown.toggle()
                }
                .emojiPicker(
                    isPresented: $isEmojiSelectorShown,
                    selectedEmoji: $icon
                )
                
                Divider()
                
                TextField("Name", text: $name)
            }
        }
        .navigationTitle("New trigger")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            Button("Create") {
                create()
                dismiss()
            }
            .disabled(name.isEmpty)
        })
    }
}

#Preview {
    NavigationStack {
        TriggerCreateScreen()
            // .modelContainer(previewContainer)
    }
}
