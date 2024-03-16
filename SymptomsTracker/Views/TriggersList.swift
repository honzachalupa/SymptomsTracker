import SwiftUI
import SwiftData

struct TriggersListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Trigger.name) private var triggers: [Trigger]
    
    private func deleteTrigger(_ trigger: Trigger) {
        modelContext.delete(trigger)
    }
    
    var body: some View {
        List {
            ForEach(triggers) { trigger in
                HStack {
                    SymptomNameWithIcon(name: trigger.name, icon: trigger.icon)
                }
                .swipeActions {
                    Button("Delete", role: .destructive) {
                        deleteTrigger(trigger)
                    }
                    
                    NavigationLink {
                        TriggerEditScreen(trigger: trigger)
                    } label: {
                        Text("Edit")
                    }
                    .tint(.gray)
                }
            }
        }
    }
}

#Preview {
    TriggersListView()
        .modelContainer(previewContainer)
}
