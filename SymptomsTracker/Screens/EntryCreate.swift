import SwiftUI
import SwiftData

struct EntryCreateScreen: View {
    var symptom: Symptom
    
    @Environment(\.dismiss) var dismiss
    @State var dataStore = DataStoreManager()
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
    
    private func create() {
        dataStore.create(
            Entry(
                date: date,
                severity: severity,
                triggers: selectedTriggers
            ),
            refSymptom: symptom
        )
    }
    
    var body: some View {
        NavigationStack {
            HStack(alignment: .center) {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                })
                
                Spacer()
                
                Text("New entry")
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    create()
                    dismiss()
                }, label: {
                    Text("Create")
                })
            }
            .font(.title3)
            .padding(.top, 20)
            .padding(.bottom, 8)
            .padding(.horizontal, 20)
            
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
        }
    }
}

#Preview {
    EntryCreateScreen(symptom: symptomsMock.first!)
        // .modelContainer(previewContainer)
}
