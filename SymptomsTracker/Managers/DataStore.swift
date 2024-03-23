import SwiftUI
import SwiftData

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}

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
        print("fetchSymptoms started")
        
        do {
            return try modelContext.fetch(FetchDescriptor<Symptom>(sortBy: [SortDescriptor(\.name)]))
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /* func fetchEntries() -> [Entry] {
        do {
            return try modelContext.fetch(FetchDescriptor<Entry>(sortBy: [SortDescriptor(\.date, order: .reverse)]))
        } catch {
            fatalError(error.localizedDescription)
        }
    } */
    
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
    
    func create<T: PersistentModel>(_ payload: T, refSymptom: Symptom? = nil) {
        modelContext.insert(payload)
    }

    func delete<T: PersistentModel>(_ payload: T) {
        modelContext.delete(payload)
    }
    
    func deleteAll() {
        modelContainer.deleteAllData()
        
        /* try! modelContext.delete(model: Symptom.self)
        try! modelContext.delete(model: Entry.self)
        try! modelContext.delete(model: Trigger.self) */
    }
}

@Observable
class DataStoreManager {
    private let healthKit = HealthKitManager()
    private let dataSource: DataSource
    
    var symptoms: [Symptom] = []
    // var entries: [Entry] = []
    var triggers: [Trigger] = []

    init(dataSource: DataSource = DataSource.shared) {
        self.dataSource = dataSource
    }
    
    func refreshData() {
        print("refreshData started")
        
        symptoms = self.fetchHealthKitEntries(dataSource.fetchSymptoms())
        // entries = dataSource.fetchEntries()
        triggers = dataSource.fetchTriggers()
    }
    
    private func fetchHealthKitEntries(_ symptoms: [Symptom]) -> [Symptom] {
        var symptomsClone: [Symptom] = []
        
        symptoms.forEach { symptom in
            let symptomClone: Symptom = symptom
            
            print("HERE", 111, symptom.healthKitType?.key)
            
            if let typeIdentifier = symptom.healthKitType?.key {
                healthKit.read(typeIdentifier, triggersDefinition: []) { entries in
                    print("HERE", 222, entries)
                    
                    var entriesClone: [Entry] = []
                    
                    entries.forEach { entry in
                        entriesClone.append(entry)
                    }
                    
                    print("HERE", 333, entriesClone)
                    
                    symptomClone.entries = entriesClone
                }
                
                print("HERE", 444, symptomClone.entries)
            }
            
            print("HERE", 555, symptomClone)
            
            symptomsClone.append(symptomClone)
        }
        
        print("HERE", 555, symptomsClone)
        
        symptomsClone.forEach { symptom in
            print("xxxxxxx", symptom.name, symptom.healthKitType, symptom.entries)
        }
        
        return symptomsClone
    }

    func create<T: PersistentModel>(_ payload: T, refSymptom: Symptom? = nil) {
        dataSource.create(payload, refSymptom: refSymptom)
        
        if let entry = payload as? Entry, type(of: payload) == Entry.self {
            guard let healthKitType = refSymptom?.healthKitType else { return }
            
            healthKit.write(
                healthKitType.key,
                entry
            ) {
                self.refreshData()
            }
        }
    }

    func delete<T: PersistentModel>(_ payload: T, refSymptom: Symptom? = nil) {
        // dataSource.delete(payload)
        
        if let entry = payload as? Entry, type(of: payload) == Entry.self {
            guard let healthKitType = refSymptom?.healthKitType else { return }
            
            healthKit.delete(entry.id, healthKitType.key) {
                self.refreshData()
            }
        }
    }
    
    func deleteAll() {
        dataSource.deleteAll()
        
        symptoms = []
        // entries = []
        triggers = []
    }
}

struct DataStoreManagerPreview: View {
    @State var dataStore = DataStoreManager()
    
    var body: some View {
        List {
            Section("Symptoms") {
                ForEach(dataStore.symptoms, id: \.self) { item in
                    Text(item.name)
                }
            }
            
            /* Section("Entries") {
                ForEach(dataStore.entries, id: \.self) { item in
                    Text(item.date.formatted())
                }
            }*/
            
            Section("Triggers") {
                ForEach(dataStore.triggers, id: \.self) { item in
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
            .onAppear(perform: {
                /* if dataStore.symptoms.isEmpty {
                    dataStore.symptoms = symptomsMock
                }
                
                /* if dataStore.entries.isEmpty {
                    dataStore.entries = entriesMock
                } */
                
                if dataStore.triggers.isEmpty {
                    dataStore.triggers = triggersMock
                } */
                
                dataStore.refreshData()
            })
    }
}

#Preview {
    DataStoreManagerPreviewWrapper {
        DataStoreManagerPreview()
    }
}
