import SwiftUI

enum TabKey {
    case symptoms, triggers
}

struct RootScreen: View {
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
                SymptonsListView().tabItem {
                    Label("Symptoms", systemImage: "chart.bar.xaxis")
                }
                .tag(TabKey.symptoms)
                
                TriggersListView().tabItem {
                    Label("Triggers", systemImage: "list.bullet")
                }
                .tag(TabKey.triggers)
            }
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationTitle(navigationTitle)
            .toolbar {
                switch selectedTabKey {
                    case .symptoms:
                        ToolbarItem {
                            NavigationLink {
                                SymptomCreateScreen()
                            } label: {
                                Label("Add Symptom", systemImage: "plus")
                            }
                        }
                    case .triggers:
                        ToolbarItem {
                            NavigationLink {
                                TriggerCreateScreen()
                            } label: {
                                Label("Add Trigger", systemImage: "plus")
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
