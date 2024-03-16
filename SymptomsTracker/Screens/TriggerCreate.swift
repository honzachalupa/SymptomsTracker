import SwiftUI
import SwiftData
import MCEmojiPicker

struct TriggerCreateScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var icon: String = ""
    @State private var isEmojiSelectorShown: Bool = false
    
    private func createTrigger() {
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
        .navigationTitle("Add Trigger")
        .toolbar(content: {
            Button("Add") {
                createTrigger()
                dismiss()
            }
            .disabled(name.isEmpty)
        })
    }
}

#Preview {
    TriggerCreateScreen()
        .modelContainer(previewContainer)
}
