import SwiftUI
import SwiftData

struct EntryCreateScreen: View {
    let healthKit = HealthKitManager()
    
    var symptom: Symptom
    
    @Environment(\.dismiss) var dismiss
    
    @State private var dataStore = DataStoreManager()
    @State private var date: Date = Date()
    @State private var severity: Severity = .moderate
    @State private var selectedTriggers: [Trigger] = []
    
    private func selectTrigger(_ trigger: Trigger) {
        if selectedTriggers.contains(trigger) {
            selectedTriggers.remove(at: selectedTriggers.firstIndex(of: trigger)!)
        } else {
            selectedTriggers.append(trigger)
        }
    }
    
    private func createEntry() {
        symptom.entries!.append(
            Entry(
                date: date,
                severity: severity,
                triggers: selectedTriggers
            )
        )
    }
    
    private func create() {
        if let healthKitType = symptom.healthKitType {
            let data = WriteDataModel(
                severity: severity,
                triggerIDsString: selectedTriggers.map { $0.id.uuidString }.joined(separator: ";")
            )
            
            healthKit.write(healthKitType.key, data: data) { success in
                print(777)
                
                // createEntry()
            }
        } else {
            createEntry()
        }
    }
    
    var body: some View {
        NavigationStack {
            Text("New entry")
                .fontWeight(.medium)
                .padding(.top, 10)
            
            List {
                DatePicker("Date", selection: $date)
                
                Picker("Severity", selection: $severity) {
                    ForEach(Severity.allCases, id: \.self) { severity in
                        Text(getSeverityLabel(severity))
                            .tag(severity)
                    }
                }
                
                Section("Triggers") {
                    ForEach(dataStore.triggers) { trigger in
                        Toggle(isOn: Binding(
                            get: {
                                selectedTriggers.contains(trigger)
                            },
                            set: { value in
                                if value {
                                    selectedTriggers.append(trigger)
                                } else {
                                    selectedTriggers.removeAll { $0 == trigger }
                                }
                            }
                        )) {
                            SymptomNameWithIcon(name: trigger.name, icon: trigger.icon)
                        }
                    }
                    
                    if dataStore.triggers.isEmpty {
                        NavigationLink {
                            TriggerCreateScreen()
                        } label: {
                            Text("New trigger")
                        }

                    }
                }
            }
            
            Button("Create") {
                create()
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    EntryCreateScreen(symptom: symptomsMock.first!)
        .modelContainer(previewContainer)
}
