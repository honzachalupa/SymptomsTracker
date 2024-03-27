import SwiftUI
import SwiftData
import CoreData

// https://dev.to/jameson/swiftui-with-swiftdata-through-repository-36d1

class DataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = DataSource()

    @MainActor
    private init() {
        let types: [any PersistentModel.Type] = [
            Symptom.self,
            Entry.self,
            Trigger.self,
            HealthKitType.self,
            Insight.self
        ]
        
        let schema = Schema(types)
        
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        /* #if DEBUG
         do {
             // Use an autorelease pool to make sure Swift deallocates the persistent
             // container before setting up the SwiftData stack.
             try autoreleasepool {
                 let desc = NSPersistentStoreDescription(url: config.url)
                 let opts = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.janchalupa.SymptomsTracker")
                 desc.cloudKitContainerOptions = opts
                 // Load the store synchronously so it completes before initializing the
                 // CloudKit schema.
                 desc.shouldAddStoreAsynchronously = false
                 if let mom = NSManagedObjectModel.makeManagedObjectModel(for: types) {
                     let container = NSPersistentCloudKitContainer(name: "SymptomsTracker", managedObjectModel: mom)
                     container.persistentStoreDescriptions = [desc]
                     container.loadPersistentStores {_, err in
                         if let err {
                             fatalError(err.localizedDescription)
                         }
                     }
                     // Initialize the CloudKit schema after the store finishes loading.
                     try container.initializeCloudKitSchema()
                     // Remove and unload the store from the persistent container.
                     if let store = container.persistentStoreCoordinator.persistentStores.first {
                         try container.persistentStoreCoordinator.remove(store)
                     }
                 }
             }
         } catch {
             fatalError(error.localizedDescription)
         }
         #endif */
        
        self.modelContainer = try! ModelContainer(
            for: schema,
            configurations: config
        )
        
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
        if type(of: payload) == Entry.self {
            guard let symptom = refSymptom else {
                print("Attribute \"refSymptom\" must be provied when creating Entry.")
                return
            }
            
            symptom.entries?.append(payload as! Entry)
            
            consoleLog("creating entry \(symptom)", payload)
        } else {
            modelContext.insert(payload)
            
            consoleLog("creating \(type(of: payload))", payload)
        }
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
    
    /* @Published var symptoms: [Symptom] = []
     @Published var triggers: [Trigger] = []
     @Published var insights: [Insight] = []
     @Published var isLoading: Bool = true */

    init(dataSource: DataSource = DataSource.shared) {
        self.dataSource = dataSource
        
        Task {
            await self.refreshData()
        }
    }
    
    func refreshData() async {
        // symptoms = await self.fetchHealthKitEntries(dataSource.fetchSymptoms())
        symptoms = await dataSource.fetchSymptoms()
        triggers = await dataSource.fetchTriggers()
        insights = await dataSource.fetchInsights()
        
        consoleLog("DATA_MANAGER", [symptoms, triggers])
        
        symptoms.forEach { symptom in
            consoleLog("DATA_MANAGER - Symptom", symptom)
            
            symptom.entries!.forEach { entry in
                consoleLog("DATA_MANAGER - Entries", entry.severity)
            }
        }
        
        isLoading = false
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
        
       
        if let entry = payload as? Entry, type(of: payload) == Entry.self {
            guard let healthKitType = refSymptom?.healthKitType else { return }
            
            Task {
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
