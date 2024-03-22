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
            return try modelContext.fetch(FetchDescriptor<Symptom>(sortBy: [SortDescriptor(\.name)]))
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchEntries() -> [Entry] {
        do {
            return try modelContext.fetch(FetchDescriptor<Entry>(sortBy: [SortDescriptor(\.date, order: .reverse)]))
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchTriggers() -> [Trigger] {
        do {
            return try modelContext.fetch(FetchDescriptor<Trigger>(sortBy: [SortDescriptor(\.name)]))
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func save() {
        try! modelContext.save()
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
    var subscribedTypeIdentifiers: [TypeIdentifier] = []

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

struct DataStoreManagerPreviewWrapper<Content: View>: View {
    @State private var dataStore = DataStoreManager()
    
    @ViewBuilder let content: Content
    
    var body: some View {
        ZStack{
            content
        }
            .onAppear(perform: {
                if dataStore.symptoms.isEmpty {
                    dataStore.symptoms = symptomsMock
                }
                
                if dataStore.entries.isEmpty {
                    dataStore.entries = entriesMock
                }
                
                if dataStore.triggers.isEmpty {
                    dataStore.triggers = triggersMock
                }
                
                dataStore.refreshData()
            })
    }
}

#Preview {
    DataStoreManagerPreviewWrapper {
        DataStoreManagerPreview()
    }
}
