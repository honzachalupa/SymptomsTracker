import SwiftUI
import SwiftData

struct TriggersListView: View {
    @State private var dataStore = DataStoreManager()
    
    var body: some View {
        List(dataStore.triggers, id: \.id) { trigger in
            NavigationLink {
                TriggerEditScreen(trigger: trigger)
            } label: {
                SymptomNameWithIcon(name: trigger.name, icon: trigger.icon)
            }
            .swipeActions {
                Button("Delete", role: .destructive) {
                    dataStore.delete(trigger)
                }
            }
        }
    }
}

#Preview {
    TriggersListView()
        // .modelContainer(previewContainer)
}
