import SwiftUI
import SwiftData

class DataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = DataSource()

    @MainActor
    private init() {
        do {
            self.modelContainer = try ModelContainer(for:
                Symptom.self,
                Entry.self,
                Trigger.self,
                HealthKitType.self
                // Insight.self
            )
        } catch {
            fatalError(error.localizedDescription)
        }
        self.modelContext = modelContainer.mainContext
    }
    
    func fetchSymptoms() async -> [Symptom] {
        do {
            return try modelContext.fetch(FetchDescriptor<Symptom>(sortBy: [SortDescriptor(\.name)]))
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchTriggers() async -> [Trigger] {
        do {
            return try modelContext.fetch(FetchDescriptor<Trigger>(sortBy: [SortDescriptor(\.name)]))
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchInsights() async -> [Insight] {
        do {
            return try modelContext.fetch(FetchDescriptor<Insight>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func save() {
        try! modelContext.save()
    }
    
    func create<T: PersistentModel>(_ payload: T, refSymptom: Symptom? = nil) {
        modelContext.insert(payload)
    }

    func delete<T: PersistentModel>(_ payload: T) {
        modelContext.delete(payload)
    }
    
    func deleteAll() {
        modelContainer.deleteAllData()
    }
}

@Observable
class DataStoreManager: ObservableObject {
    private let healthKit = HealthKitManager()
    private let dataSource: DataSource
    
    var symptoms: [Symptom] = []
    var triggers: [Trigger] = []
    var insights: [Insight] = []
    var isLoading: Bool = true

    init(dataSource: DataSource = DataSource.shared) {
        self.dataSource = dataSource
    }
    
    func refreshData() async {
        consoleLog("STARTED: refreshData")
        
        // symptoms = await self.fetchHealthKitEntries(dataSource.fetchSymptoms())
        symptoms = await dataSource.fetchSymptoms()
        triggers = await dataSource.fetchTriggers()
        insights = await dataSource.fetchInsights()
        
        isLoading = false
        
        consoleLog("FINISHED: refreshData")
    }
    
    private func fetchHealthKitEntries(_ symptoms: [Symptom]) async -> [Symptom] {
        var symptomsClone: [Symptom] = []
        
        symptoms.forEach { symptom in
            let symptomClone: Symptom = symptom
            
            consoleLog("fetchHealthKitEntries 1", symptom.healthKitType?.key)
            
            if let typeIdentifier = symptom.healthKitType?.key {
                Task {
                    await healthKit.read(typeIdentifier, triggersDefinition: []) { entries in
                        consoleLog("fetchHealthKitEntries 2", entries)
                        
                        var entriesClone: [Entry] = []
                        
                        entries.forEach { entry in
                            entriesClone.append(entry)
                        }
                        
                        consoleLog("fetchHealthKitEntries 3", entriesClone)
                        
                        symptomClone.entries = entriesClone
                    }
                    
                    consoleLog("fetchHealthKitEntries 4", symptomClone.entries)
                }
            }
            
            consoleLog("fetchHealthKitEntries 5", symptomClone)
            
            symptomsClone.append(symptomClone)
        }
        
        consoleLog("fetchHealthKitEntries 5", symptomsClone)
        
        symptomsClone.forEach { symptom in
            consoleLog("fetchHealthKitEntries 6", symptom)
        }
        
        return symptomsClone
    }

    func create<T: PersistentModel>(_ payload: T, refSymptom: Symptom? = nil) async {
        dataSource.create(payload, refSymptom: refSymptom)
        
        Task {
            if let entry = payload as? Entry, type(of: payload) == Entry.self {
                guard let healthKitType = refSymptom?.healthKitType else { return }
                
                await healthKit.write(
                    healthKitType.key,
                    entry
                )
                
                await self.refreshData()
            }
        }
    }

    func delete<T: PersistentModel>(_ payload: T, refSymptom: Symptom? = nil) async {
        consoleLog("DELETE STARTED")
        
        if let entry = payload as? Entry, type(of: payload) == Entry.self {
            consoleLog("DELETE HK STARTED")
            
            guard let healthKitType = refSymptom?.healthKitType else { return }
            
            Task {
                await healthKit.delete(entry.id, healthKitType.key)
                
                consoleLog("DELETE HK FINISHED")
            }
        }
        
        dataSource.delete(payload)
        
        consoleLog("DELETE FINISHED")
        
        await refreshData()
        
        consoleLog("DELETE REFRESHING DATA")
    }
    
    func deleteAll() {
        dataSource.deleteAll()
        
        /* symptoms = []
        triggers = []
        insights = [] */
    }
}

struct DataStoreManagerPreview: View {
    @EnvironmentObject var dataStore: DataStoreManager
    
    var body: some View {
        List {
            Section("Symptoms") {
                ForEach(dataStore.symptoms, id: \.id) { item in
                    Text(item.name)
                    
                    Text("Entries")
                    
                    if let entries = item.entries {
                        ForEach(entries, id: \.id) { entry in
                            Text(entry.date.formatted())
                        }
                    }
                }
            }
            
            Section("Triggers") {
                ForEach(dataStore.triggers, id: \.id) { item in
                    Text(item.name)
                }
            }
        }
    }
}

struct DataStoreManagerPreviewWrapper<Content: View>: View {
    @State var dataStore = DataStoreManager()
    
    @ViewBuilder let content: Content
    
    var body: some View {
        ZStack{
            content
        }
        .task({
            /* if dataStore.symptoms.isEmpty {
                dataStore.symptoms = symptomsMock
            }
            
            if dataStore.entries.isEmpty {
                dataStore.entries = entriesMock
            }
            
            if dataStore.triggers.isEmpty {
                dataStore.triggers = triggersMock
            } */
            
            await dataStore.refreshData()
        })
    }
}

#Preview {
    DataStoreManagerPreviewWrapper {
        DataStoreManagerPreview()
    }
}
