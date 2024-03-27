import SwiftUI
import SwiftData

@main
struct SymptomsTrackerApp: App {
    @StateObject private var dataStore = DataStoreManager()
    
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environmentObject(dataStore)
        }
        /* .modelContainer(for: [
            Symptom.self,
            Entry.self,
            Trigger.self,
            HealthKitType.self,
            Insight.self
        ]) */
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        #endif
    }
}
