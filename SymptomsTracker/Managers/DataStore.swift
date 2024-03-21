import SwiftUI
import SwiftData

final class DataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = DataSource()

    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for:
            Symptom.self,
            Entry.self,
            Trigger.self,
            HealthKitType.self
        )
        self.modelContext = modelContainer.mainContext
    }
    
    func fetchSymptoms() -> [Symptom] {
        do {
            return try modelContext.fetch(FetchDescriptor<Symptom>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchEntries() -> [Entry] {
        do {
            return try modelContext.fetch(FetchDescriptor<Entry>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchTriggers() -> [Trigger] {
        do {
            return try modelContext.fetch(FetchDescriptor<Trigger>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func create<T: PersistentModel>(_ payload: T) {
        modelContext.insert(payload)
    }

    func remove<T: PersistentModel>(_ payload: T) {
        modelContext.delete(payload)
    }
}

@Observable
class DataStoreManager {
    @ObservationIgnored
    private let dataSource: DataSource

    var symptoms: [Symptom] = symptomsMock
    var entries: [Entry] = entriesMock
    var triggers: [Trigger] = triggersMock
    var subscribedTypeIdentifiers: [TypeIdentifiers] = []

    init(dataSource: DataSource = DataSource.shared) {
        self.dataSource = dataSource
        
        refreshData()
    }
    
    func refreshData() {
        symptoms = dataSource.fetchSymptoms()
        entries = dataSource.fetchEntries()
        triggers = dataSource.fetchTriggers()
        
        subscribedTypeIdentifiers = removeDuplicates(
            symptoms
                .filter { $0.healthKitType != nil }
                .map { $0.healthKitType!.key }
        )
        
        print("DataStoreManager - symptoms typeIdentifiers", subscribedTypeIdentifiers)
        
        // TODO: reloadHealthKitData
    }

    func create<T: PersistentModel>(_ payload: T) {
        dataSource.create(payload)
    }

    func delete<T: PersistentModel>(_ payload: T) {
        dataSource.remove(payload)
    }
}

struct DataStoreManagerPreview: View {
    @State private var dataStore = DataStoreManager()
    
    var body: some View {
        List {
            Section("Symptoms") {
                ForEach(dataStore.symptoms, id: \.self) { item in
                    Text(item.name)
                }
            }
            
            Section("Entries") {
                ForEach(dataStore.entries, id: \.self) { item in
                    Text(item.date.formatted())
                }
            }
            
            Section("Triggers") {
                ForEach(dataStore.triggers, id: \.self) { item in
                    Text(item.name)
                }
            }
        }
    }
}

#Preview {
    DataStoreManagerPreview()
        .modelContainer(previewContainer)
}
