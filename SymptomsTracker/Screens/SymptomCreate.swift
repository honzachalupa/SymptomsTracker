import SwiftUI
import SwiftData
import MCEmojiPicker

struct SymptomCreateScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var note: String = ""
    @State private var icon: String = ""
    @State private var isEmojiSelectorShown: Bool = false
    
    private func createSymptom() {
        withAnimation {
            modelContext.insert(
                Symptom(
                    name: name,
                    icon: icon,
                    note: note
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
            
            TextField("Note", text: $note)
        }
        .navigationTitle("Add Symptom")
        .toolbar(content: {
            Button("Add") {
                createSymptom()
                dismiss()
            }
            .disabled(name.isEmpty)
        })
    }
}

#Preview {
    SymptomCreateScreen()
}
