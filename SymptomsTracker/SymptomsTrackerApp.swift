import SwiftUI
import SwiftData

// TODO: How to work with ENV secrets?

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
    }
}
