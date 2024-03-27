import SwiftUI
import SwiftData

struct TriggersListSectionView: View {
    @EnvironmentObject var dataStore: DataStoreManager
    
    func delete(_ trigger: Trigger) {
        Task {
            await dataStore.delete(trigger)
        }
    }
    
    var body: some View {
        Section("Triggers") {
            ForEach(dataStore.triggers, id: \.id) { trigger in
                NavigationLink {
                    TriggerEditScreen(trigger: trigger)
                } label: {
                    Group {
                        if UIDevice.isIPad {
                            SymptomNameWithIcon(trigger.name, trigger.icon, spacing: 3)
                        } else {
                            SymptomNameWithIcon(trigger.name, trigger.icon, spacing: 8)
                        }
                    }
                    .padding(.leading, 3)
                }
                .swipeActions {
                    Button("Delete", role: .destructive) {
                        delete(trigger)
                    }
                }
            }
            
            NavigationLink {
                TriggerCreateScreen()
            } label: {
                Label("Create trigger", systemImage: "plus")
                    
            }
        }
    }
}

#Preview {
    TriggersListSectionView()
        // .modelContainer(previewContainer)
}
