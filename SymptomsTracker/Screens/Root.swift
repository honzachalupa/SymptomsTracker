import SwiftUI
import SwiftData

enum TabKey {
    case symptoms, triggers, settings
}

struct RootScreen: View {
    @Environment(\.scenePhase) var scenePhase
    
    let healthKitConntector = HealthKitConnector()
    
    @Query private var symptoms: [Symptom]
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
            if symptom.healthKitTypeIdentifier != nil {
                print(666, "START")
                print(2, symptom)
                
                guard let identifier = symptom.healthKitTypeIdentifier else {
                    return
                }
                
                print(3, identifier)
                
                healthKitConntector.readHKSample(identifier) { newEntries in
                    print(4, newEntries)
                    
                    newEntries.forEach { newEntry in
                        print(5, newEntry, symptom.entries)
                        
                        guard var existingEntries = symptom.entries else {
                            print(8)
                            symptom.entries = [newEntry]
                            return
                        }
                        
                        print(6, existingEntries)
                        
                        if !existingEntries.contains(newEntry) {
                            print(7, newEntry)
                            existingEntries.append(newEntry)
                        }
                        
                        symptom.entries = newEntries
                    }
                    
                    print(666, "END")
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
