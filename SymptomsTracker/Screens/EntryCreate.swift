import SwiftUI
import SwiftData

struct EntryCreateScreen: View {
    var symptom: Symptom
    
    @Query(sort: \Trigger.name) private var triggers: [Trigger]
    @Environment(\.dismiss) var dismiss
    
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
    
    private func save() {
        symptom.entries!.append(
            Entry(
                date: date,
                severity: severity,
                triggers: selectedTriggers
            )
        )
    }
    
    var body: some View {
        Text("Add Entry")
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
        }
        
        List() {
            Section("Triggers") {
                ForEach(triggers) { trigger in
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
            }
        }
        
        Button("Save") {
            save()
            dismiss()
        }
        .buttonStyle(BorderedProminentButtonStyle())
    }
}

#Preview {
    EntryCreateScreen(symptom: symptomMock)
}
