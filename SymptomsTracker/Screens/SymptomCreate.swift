import SwiftUI
import SwiftData
import MCEmojiPicker

enum SymptomOrigin: CaseIterable {
    case healthKit, manual
}

struct SymptomCreateScreen: View {
    let healthKitConntector = HealthKitConnector()
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var origin: SymptomOrigin = .healthKit
    @State private var selectedHKSymptom: Symptom = HealthKitSymptoms.first!
    @State private var name: String = ""
    @State private var note: String = ""
    @State private var icon: String = ""
    @State private var isEmojiSelectorShown: Bool = false
    
    private func create() {
        withAnimation {
            if origin == .manual {
                modelContext.insert(
                    Symptom(
                        name: name,
                        icon: icon,
                        note: note
                    )
                )
            } else {
                if let typeIdentifier = selectedHKSymptom.typeIdentifier {
                    healthKitConntector.requestPermissions(typeIdentifier)
                    
                    modelContext.insert(
                        Symptom(
                            name: selectedHKSymptom.name,
                            icon: selectedHKSymptom.icon,
                            typeIdentifier: typeIdentifier,
                            note: selectedHKSymptom.note
                        )
                    )
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            Picker("", selection: $origin) {
                ForEach(SymptomOrigin.allCases, id: \.self) { origin in
                    Text(getOriginLabel(origin))
                        .tag(origin)
                }
            }
            .pickerStyle(.palette)
            .padding(.horizontal)
            
            if origin == .manual {
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
            } else {
                List {
                    Picker("Data type", selection: $selectedHKSymptom) {
                        ForEach(HealthKitSymptoms) { symptom in
                            SymptomNameWithIcon(name: symptom.name, icon: symptom.icon)
                                .tag(symptom)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
            }
        }
        .navigationTitle("New symptom")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            Button("Create") {
                create()
                dismiss()
            }
            .disabled(name.isEmpty && origin == .manual)
        })
    }
}

#Preview {
    NavigationStack {
        SymptomCreateScreen()
            .modelContainer(previewContainer)
    }
}
