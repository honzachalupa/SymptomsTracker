import SwiftUI
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for:
                Symptom.self,
                Trigger.self,
                Entry.self,
                HealthKitType.self,
                Insight.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )
        
        symptomsMock.forEach { entry in
            container.mainContext.insert(entry)
        }
        
        return container
    } catch {
        fatalError("Failed to create Preview Container")
    }
}()
