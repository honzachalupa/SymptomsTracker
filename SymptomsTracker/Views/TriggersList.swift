import SwiftUI
import SwiftData

struct TriggersListView: View {
    @State var dataStore = DataStoreManager()
    
    func delete(_ trigger: Trigger) {
        Task {
            await dataStore.delete(trigger)
        }
    }
    
    var body: some View {
        List(dataStore.triggers, id: \.id) { trigger in
            NavigationLink {
                TriggerEditScreen(trigger: trigger)
            } label: {
                SymptomNameWithIcon(name: trigger.name, icon: trigger.icon)
            }
            .swipeActions {
                Button("Delete", role: .destructive) {
                    delete(trigger)
                }
            }
        }
        .task {
            // await dataStore.refreshData()
        }
    }
}

#Preview {
    TriggersListView()
        // .modelContainer(previewContainer)
}
