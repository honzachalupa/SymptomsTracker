import SwiftUI

enum TabKey {
    case symptoms, triggers
}

struct RootScreen: View {
    // let healthKitConntector = HealthKitConnector()
    
    @State private var selectedTabKey: TabKey = .symptoms
    
    var navigationTitle: String {
        switch selectedTabKey {
            case .symptoms:
                return String(localized: "Symptoms")
            case .triggers:
                return String(localized: "Triggers")
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
            }
            .navigationTitle(navigationTitle)
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                switch selectedTabKey {
                    case .symptoms:
                        ToolbarItem {
                            NavigationLink {
                                SymptomCreateScreen()
                            } label: {
                                Label("Create symptom", systemImage: "plus")
                            }
                        }
                    case .triggers:
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
        .modelContainer(previewContainer)
}
