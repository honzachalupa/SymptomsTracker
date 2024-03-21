import SwiftUI
import SwiftData

struct TriggersListView: View {
    @State private var dataStore = DataStoreManager()
    
    var body: some View {
        List {
            ForEach(dataStore.triggers) { trigger in
                HStack {
                    SymptomNameWithIcon(name: trigger.name, icon: trigger.icon)
                }
                .swipeActions {
                    Button("Delete", role: .destructive) {
                        dataStore.delete(trigger)
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
