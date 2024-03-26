import SwiftUI
import SwiftData

@main
struct SymptomsTrackerApp: App {
    @ObservedObject private var dataStore = DataStoreManager()
    
    var body: some Scene {
        WindowGroup {
            RootScreen()
                .environmentObject(dataStore)
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        #endif
    }
}
