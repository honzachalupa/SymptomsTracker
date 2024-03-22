import SwiftUI
import SwiftData

enum TabKey {
    case symptoms, triggers, settings
}

struct RootScreen: View {
    @Environment(\.scenePhase) var scenePhase

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
            // .toolbarTitleDisplayMode(.inlineLarge)
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
        }
    }
}

#Preview {
    RootScreen()
}
