import SwiftUI
import SwiftData

enum TabKey {
    case symptoms, triggers, settings
}

struct RootScreen: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var dataStore: DataStoreManager
    @State private var selectedSymptom: Symptom?
    @State private var isSidebarExpanded: NavigationSplitViewVisibility = .doubleColumn
    
    var body: some View {
        NavigationSplitView(columnVisibility: $isSidebarExpanded) {
            if dataStore.symptoms.isEmpty {
                Text("Add a your first symptom to start tracking.")
                    .opacity(0.8)
                    .padding(.top, 25)
            }
            
            List {
                SymptomsListSectionView(selectedSymptom: $selectedSymptom)
                TriggersListSectionView()
            }
            .listStyle(.sidebar)
            .navigationTitle("Symptoms")
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        SettingsScreen()
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
            }
            .refreshable {
                Task {
                    await dataStore.refreshData()
                }
            }
        } detail: {
            if let symptom = selectedSymptom {
                SymptomDetailScreen(symptom: symptom)
                    .navigationTitle(symptom.name)
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onChange(of: dataStore.symptoms) { _, newValue in
            consoleLog("DATASTORE onChange", newValue);
            consoleLog("DATASTORE onChange isEmpty", dataStore.symptoms.isEmpty);
        }
    }
}

#Preview {
    RootScreen()
}
