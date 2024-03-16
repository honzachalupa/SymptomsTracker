import SwiftUI
import SwiftData
import MCEmojiPicker

struct TriggerCreateScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var icon: String = ""
    @State private var isEmojiSelectorShown: Bool = false
    
    private func create() {
        withAnimation {
            modelContext.insert(
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
            .modelContainer(previewContainer)
    }
}
