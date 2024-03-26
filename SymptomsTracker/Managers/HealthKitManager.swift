import HealthKit

func convertTypeIdentifier(_ _typeIdentifier: TypeIdentifier) -> HKCategoryTypeIdentifier {
    guard let typeIdentifier = typeIdentifierMapping[_typeIdentifier] else {
        fatalError("Unable to convert typeIdentifier to HKCategoryTypeIdentifier")
    }
    
    return typeIdentifier
}

struct HealthKitManager {
    var healthStore: HKHealthStore = HKHealthStore()
    public var isHealthKitSupported: Bool = true

    init() {
        if !HKHealthStore.isHealthDataAvailable() {
            print("This app requires a device that supports HealthKit")
            
            isHealthKitSupported = false
        }
    }
    
    func requestPermissions(_ _typeIdentifier: TypeIdentifier) {
        if isHealthKitSupported {
            let typeIdentifier = HKObjectType.categoryType(
                forIdentifier: convertTypeIdentifier(_typeIdentifier)
            )!
            
            healthStore.requestAuthorization(toShare: [typeIdentifier], read: [typeIdentifier]) { _, error in
                if let error = error {
                    print("Error requesting HealthKit authorization", error)
                }
            }
        }
    }
    
    func write(_ _typeIdentifier: TypeIdentifier, _ entry: Entry) async {
        if isHealthKitSupported {
            let sampleType = HKObjectType.categoryType(forIdentifier: convertTypeIdentifier(_typeIdentifier))!
            let sample = HKCategorySample(
                type: sampleType,
                value: encodeSymptomSeverity(entry.severity),
                start: entry.date,
                end: entry.date,
                metadata: [
                    "triggerIDs": "" // entry.triggers.map { $0.id.uuidString }.joined(separator: ";")
                ]
            )
            
            entry.triggers?.forEach { trigger in
                consoleLog("TRIGGER", trigger)
            }
            
            do {
                try await healthStore.save(sample)
            } catch {
                print("Error saving sample: \(error)")
            }
        }
    }
    
    func read(_ _typeIdentifier: TypeIdentifier, triggersDefinition: [Trigger], completion: @escaping ([Entry]) -> Void) async {
        if isHealthKitSupported {
            let typeIdentifier = convertTypeIdentifier(_typeIdentifier)
            let authStatus = healthStore.authorizationStatus(for: HKObjectType.categoryType(forIdentifier: typeIdentifier)!)
            
            if authStatus == .sharingAuthorized {
                let sampleType = HKObjectType.categoryType(forIdentifier: typeIdentifier)!
                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
                
                let sampleQuery = HKSampleQuery(
                    sampleType: sampleType,
                    predicate: getPredicate(.year),
                    limit: HKObjectQueryNoLimit,
                    sortDescriptors: [sortDescriptor],
                    resultsHandler: { query, results, error in
                        guard let samples = results as? [HKCategorySample] else {
                            if let error = error {
                                print(error)
                            }
                            completion([])
                            return
                        }
                        
                        var entries: [Entry] = []
                        
                        for sample in samples {
                            var triggers: [Trigger] = []
                            
                            if let metadata = sample.metadata, let _triggerIDs: String = metadata["triggerIDs"] as? String {
                                let triggersIDs: [String] = _triggerIDs.split(separator: ";").map { String($0) }
                                
                                triggers = triggersDefinition.filter { trigger in
                                    triggersIDs.contains(trigger.id.uuidString)
                                }
                            }
                            
                            let entry = Entry(
                                id: sample.uuid,
                                date: sample.startDate,
                                severity: self.decodeSymptomSeverity(sample.value),
                                triggers: triggers
                            )
                            
                            entries.append(entry)
                        }
                        
                        completion(entries)
                    }
                )
                
                healthStore.execute(sampleQuery)
            } else {
                fatalError("HealthKit authorization status is not sharingAuthorized.")
                
                // requestPermissions(_typeIdentifier)
                // readHKSample(_typeIdentifier)
            }
        }
    }
    
    func delete(_ id: UUID, _ _typeIdentifier: TypeIdentifier) async {
        if isHealthKitSupported {
            let sampleType = HKObjectType.categoryType(forIdentifier: convertTypeIdentifier(_typeIdentifier))!
            let predicate = HKQuery.predicateForObjects(with: [id])
            
            do {
                try await healthStore.deleteObjects(of: sampleType, predicate: predicate)
                
                consoleLog("FINISHED: healthStore.deleteObjects")
            } catch {
                print("Error deleting an entry: \(error)")
            }
        }
    }
    
    private func decodeSymptomSeverity(_ sampleValue: Int) -> Severity {
        switch sampleValue {
            case 2:
                return .mild
            case 4:
                return .severe
            default:
                return .moderate
        }
    }
    
    private func encodeSymptomSeverity(_ sampleValue: Severity) -> Int {
        switch sampleValue {
            case .mild:
                return 2
            case .severe:
                return 4
            default:
                return 3
        }
    }
    
    private func getPredicate(_ byAdding: Calendar.Component) -> NSPredicate {
        let startDate = Calendar.current.date(byAdding: byAdding, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: [])
        
        return predicate
    }
}
