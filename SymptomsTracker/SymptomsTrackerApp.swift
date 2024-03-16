import SwiftUI
import SwiftData

@main
struct SymptomsTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Symptom.self,
            Trigger.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootScreen()
        }
        // .modelContainer(sharedModelContainer)
        .modelContainer(for: [
            Symptom.self,
            Trigger.self
        ])
    }
}
