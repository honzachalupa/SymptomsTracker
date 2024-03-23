import SwiftUI
import SwiftData
import MCEmojiPicker

enum SymptomOrigin: CaseIterable {
    case healthKit, manual
}

struct SymptomCreateScreen: View {
    let healthKit = HealthKitManager()
    
    @Environment(\.dismiss) var dismiss
    @State var dataStore = DataStoreManager()
    @State private var origin: SymptomOrigin = .healthKit
    @State private var selectedHealthKitType: HealthKitType = HealthKitTypes.first!
    @State private var name: String = ""
    @State private var icon: String = ""
    @State private var note: String = ""
    @State private var isEmojiSelectorShown: Bool = false
    
    private func create() {
        withAnimation {
            if origin == .healthKit {
                healthKit.requestPermissions(selectedHealthKitType.key)
                
                dataStore.create(
                    Symptom(
                        name: selectedHealthKitType.name,
                        icon: selectedHealthKitType.icon,
                        note: selectedHealthKitType.note,
                        healthKitType: HealthKitType(
                            key: selectedHealthKitType.key,
                            name: selectedHealthKitType.name,
                            icon: selectedHealthKitType.icon,
                            note: selectedHealthKitType.note,
                            category: selectedHealthKitType.category
                        )
                    )
                )
            } else {
                dataStore.create(
                    Symptom(
                        name: name,
                        icon: icon,
                        note: note
                    )
                )
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
            
            if origin == .healthKit {
                List {
                    Picker("Data type", selection: $selectedHealthKitType) {
                        ForEach(HealthKitTypes) { type in
                            SymptomNameWithIcon(name: type.name, icon: type.icon)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
            } else {
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
            // .modelContainer(previewContainer)
    }
}
