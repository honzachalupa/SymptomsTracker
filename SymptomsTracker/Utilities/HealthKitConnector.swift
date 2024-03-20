import HealthKit

let typeIdentifierMapping: [TypeIdentifiers: HKCategoryTypeIdentifier] = [
    .headache: .headache,
    .coughing: .coughing,
    .fever: .fever,
    .acne: .acne
]

enum TypeIdentifiers: Codable {
    case headache, coughing, fever, acne
}

struct HealthKitConnector {
    var healthStore: HKHealthStore = HKHealthStore()

    init() {
        guard HKHealthStore.isHealthDataAvailable() else {
            fatalError("This app requires a device that supports HealthKit")
        }
    }
    
    func requestHealthkitPermissions(_ _identifier: TypeIdentifiers) {
        if let identifier = typeIdentifierMapping[_identifier] {
            let identifier = HKObjectType.categoryType(forIdentifier: identifier)!
            
            healthStore.requestAuthorization(toShare: [identifier], read: [identifier]) { _, error in
                if let error = error {
                    print("Error requesting HealthKit authorization", error)
                }
            }
        }
    }
    
    func readHKSample(_ _identifier: TypeIdentifiers, completion: @escaping ([Entry]) -> Void) {
        var entries: [Entry] = []
        
        if let identifier = typeIdentifierMapping[_identifier] {
            let authStatus = healthStore.authorizationStatus(for: HKObjectType.categoryType(forIdentifier: identifier)!)
            
            if authStatus == .sharingAuthorized {
                let sampleType = HKObjectType.categoryType(forIdentifier: identifier)!
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
                            completion(entries)
                            return
                        }
                        
                        for sample in samples {
                            let entry = Entry(
                                date: sample.startDate,
                                severity: self.getSymptomSeverity(sample.value),
                                triggers: []
                            )
                            
                            entries.append(entry)
                        }
                        
                        completion(entries)
                    }
                )
                
                healthStore.execute(sampleQuery)
            } else {
                requestHealthkitPermissions(_identifier)
                // readHKSample(_identifier)
            }
        }
    }
    
    private func getSymptomSeverity(_ sampleValue: Int) -> Severity {
        switch sampleValue {
            case 2:
                return Severity.mild
            case 4:
                return Severity.severe
            default:
                return Severity.moderate
        }
    }
    
    private func getPredicate(_ byAdding: Calendar.Component) -> NSPredicate {
        let startDate = Calendar.current.date(byAdding: byAdding, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: [])
        
        return predicate
    }
}
