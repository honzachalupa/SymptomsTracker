import SwiftUI
import SwiftData
import MCEmojiPicker

enum Mode {
    case healthKit, manual
}

struct SymptomCreateScreen: View {
    let healthKit = HealthKitManager()
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataStore: DataStoreManager
    @State private var mode: Mode = .healthKit
    @State private var selectedHealthKitType: HealthKitType = HealthKitTypes.first!
    @State private var name: String = ""
    @State private var icon: String = ""
    @State private var note: String = ""
    @State private var isEmojiSelectorShown: Bool = false
    
    private func create() {
        Task {
            if mode == .healthKit {
                healthKit.requestPermissions(selectedHealthKitType.key)
                
                await dataStore.create(
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
                await dataStore.create(
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
        VStack(alignment: .leading) {
            Picker("", selection: $mode) {
                Text("Add from Health app")
                    .tag(Mode.healthKit)
                
                Text("Create manualy")
                    .tag(Mode.manual)
            }
            .disabled(!healthKit.isHealthKitSupported) // TODO: HealthKitManager is not updating the value
            .pickerStyle(.palette)
            .padding(.horizontal)
            .padding(.top, 20)
            
            if !healthKit.isHealthKitSupported {
                Text("Adding symptoms from Health app is only possible on iOS devices.")
                    .foregroundStyle(.orange)
                    .opacity(0.8)
                    .padding(.horizontal)
            }
            
            List {
                if mode == .healthKit {
                    Picker("Data type", selection: $selectedHealthKitType) {
                        ForEach(HealthKitTypes) { type in
                            SymptomNameWithIconText(type.name, type.icon)
                                .tag(type)
                        }
                    }
                } else {
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
            .disabled(name.isEmpty && mode == .manual)
        })
        .onAppear() {
            if !healthKit.isHealthKitSupported {
                mode = .manual
            }
            
            consoleLog("healthKit.isHealthKitSupported 1", healthKit.isHealthKitSupported)
        }
        .onChange(of: healthKit.isHealthKitSupported) { _, newValue in
            consoleLog("healthKit.isHealthKitSupported 2", newValue)
        }
    }
}

#Preview {
    NavigationStack {
        SymptomCreateScreen()
            // .modelContainer(previewContainer)
    }
}
