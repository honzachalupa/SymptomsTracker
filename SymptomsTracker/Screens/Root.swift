import SwiftUI
import SwiftData

enum TabKey {
    case symptoms, triggers, settings
}

struct RootScreen: View {
    @Environment(\.scenePhase) var scenePhase
    
    let healthKitConntector = HealthKitConnector()
    
    @Query private var symptoms: [Symptom]
    @Query private var triggers: [Trigger]
    @State private var selectedTabKey: TabKey = .symptoms
    
    var navigationTitle: String {
        switch selectedTabKey {
            case .symptoms:
                return String(localized: "Symptoms")
            case .triggers:
                return String(localized: "Triggers")
            case .settings:
                return String(localized: "Settings")
        }
    }
    
    private func getHealthKitData() {
        symptoms.forEach { symptom in
            if symptom.typeIdentifier != nil {
                guard let typeIdentifier = symptom.typeIdentifier else {
                    return
                }
                
                healthKitConntector.read(typeIdentifier, triggersDefinition: triggers) { newEntries in
                    newEntries.forEach { newEntry in
                        guard var existingEntries = symptom.entries else {
                            symptom.entries = [newEntry]
                            return
                        }
                    
                        if !existingEntries.contains(newEntry) {
                            existingEntries.append(newEntry)
                        }
                        
                        symptom.entries = newEntries
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTabKey) {
                SymptomsListView().tabItem {
                    Label("Symptoms", systemImage: "chart.bar.xaxis")
                }
                .tag(TabKey.symptoms)
                
                TriggersListView().tabItem {
                    Label("Triggers", systemImage: "list.bullet")
                }
                .tag(TabKey.triggers)
                
                SettingsScreen().tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(TabKey.settings)
            }
            .navigationTitle(navigationTitle)
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                if selectedTabKey == .symptoms {
                    ToolbarItem {
                        NavigationLink {
                            SymptomCreateScreen()
                        } label: {
                            Label("Create symptom", systemImage: "plus")
                        }
                    }
                } else if selectedTabKey == .triggers {
                    ToolbarItem {
                        NavigationLink {
                            TriggerCreateScreen()
                        } label: {
                            Label("Create trigger", systemImage: "plus")
                        }
                    }
                }
            }
            .refreshable {
                getHealthKitData()
            }
        }
        .onAppear() {
            getHealthKitData()
        }
    }
}

#Preview {
    RootScreen()
        .modelContainer(previewContainer)
}
