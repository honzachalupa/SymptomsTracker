import SwiftUI
import SwiftData
import MCEmojiPicker

struct TriggerEditScreen: View {
    var trigger: Trigger
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var icon: String = ""
    @State private var isEmojiSelectorShown: Bool = false
    
    init(trigger: Trigger) {
        self.trigger = trigger
        _name = State(initialValue: trigger.name)
        _icon = State(initialValue: trigger.icon)
    }
    
    private func update() {
        trigger.name = name
        trigger.icon = icon
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
        .navigationTitle("Edit trigger")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            Button("Save") {
                update()
                dismiss()
            }
            .disabled(name.isEmpty)
        })
    }
}

#Preview {
    NavigationStack {
        TriggerEditScreen(trigger: triggersMock.first!)
            .modelContainer(previewContainer)
    }
}
