import SwiftUI
import SwiftData

struct EntryEditScreen: View {
    var entry: Entry
    
    @Environment(\.dismiss) var dismiss
    
    @State private var dataStore = DataStoreManager()
    @State private var date: Date = Date()
    @State private var severity: Severity = .moderate
    @State private var selectedTriggers: [Trigger] = []
    
    init(entry: Entry) {
        self.entry = entry
        _date = State(initialValue: entry.date)
        _severity = State(initialValue: entry.severity)
        _selectedTriggers = State(initialValue: entry.triggers!)
    }
    
    private func selectTrigger(_ trigger: Trigger) {
        if selectedTriggers.contains(trigger) {
            selectedTriggers.remove(at: selectedTriggers.firstIndex(of: trigger)!)
        } else {
            selectedTriggers.append(trigger)
        }
    }
    
    private func update() {
        entry.date = date
        entry.severity = severity
        entry.triggers = selectedTriggers
    }
    
    var body: some View {
        NavigationStack {
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
                        HStack {
                            SymptomNameWithIcon(name: trigger.name, icon: trigger.icon)
                            
                            if selectedTriggers.contains(trigger) {
                                Spacer()
                                
                                Image(systemName:"checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                        .onTapGesture {
                            selectTrigger(trigger)
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
        .navigationTitle("Edit trigger")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            Button("Save") {
                update()
                dismiss()
            }
        })
    }
}

#Preview {
    EntryEditScreen(entry: entriesMock.first!)
        // .modelContainer(previewContainer)
}
