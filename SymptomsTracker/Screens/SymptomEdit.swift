import SwiftUI
import SwiftData
import MCEmojiPicker

struct SymptomEditScreen: View {
    var symptom: Symptom
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var note: String = ""
    @State private var icon: String = ""
    @State private var isEmojiSelectorShown: Bool = false
    
    init(symptom: Symptom) {
        self.symptom = symptom
        _name = State(initialValue: symptom.name)
        _note = State(initialValue: symptom.note ?? "")
        _icon = State(initialValue: symptom.icon)
    }
    
    private func update() {
        symptom.name = name
        symptom.icon = icon
        symptom.note = note
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
        .navigationTitle("Edit symptom")
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
        SymptomEditScreen(symptom: symptomsMock.first!)
            // .modelContainer(previewContainer)
    }
}
