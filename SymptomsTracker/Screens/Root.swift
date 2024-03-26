import SwiftUI
import SwiftData

enum TabKey {
    case symptoms, triggers, settings
}

struct RootScreen: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var selectedSymptom: Symptom?
    @State private var isSidebarExpanded: NavigationSplitViewVisibility = .doubleColumn
    
    /* var navigationTitle: String {
        switch selectedTabKey {
            case .symptoms:
                return String(localized: "Symptoms")
            case .triggers:
                return String(localized: "Triggers")
            case .settings:
                return String(localized: "Settings")
        }
    } */
    
    var body: some View {
        NavigationSplitView(columnVisibility: $isSidebarExpanded) {
            SymptomsScreen(selectedSymptom: $selectedSymptom)
                .navigationTitle("Symptoms")
                .toolbar {
                    // if selectedTabKey == .symptoms {
                        ToolbarItem {
                            NavigationLink {
                                SymptomCreateScreen()
                            } label: {
                                Label("New symptom", systemImage: "plus")
                            }
                        }
                    
                    ToolbarItem {
                        NavigationLink {
                            SettingsScreen()
                        } label: {
                            Label("Settings", systemImage: "gearshape")
                        }
                    }
                    /* } else if selectedTabKey == .triggers {
                        ToolbarItem {
                            NavigationLink {
                                TriggerCreateScreen()
                            } label: {
                                Label("New trigger", systemImage: "plus")
                            }
                        }
                    } */
                }
            } detail: {
                if let symptom = selectedSymptom {
                    SymptomDetailScreen(symptom: symptom)
                        .navigationTitle(symptom.name)
                }
            }
            .navigationSplitViewStyle(.balanced)

            /* TabView(selection: $selectedTabKey) {
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
                         Label("New symptom", systemImage: "plus")
                     }
                 }
             } else if selectedTabKey == .triggers {
                 ToolbarItem {
                     NavigationLink {
                         TriggerCreateScreen()
                     } label: {
                         Label("New trigger", systemImage: "plus")
                     }
                 }
             }
         } */
    }
}

#Preview {
    RootScreen()
}
