import HealthKit

class HealthKitConnector: ObservableObject {
    public let healthStore: HKHealthStore
        
    init() {
        guard HKHealthStore.isHealthDataAvailable() else {
            fatalError("This app requires a device that supports HealthKit")
        }
        
        healthStore = HKHealthStore()
        requestHealthkitPermissions()
    }
    
    private func requestHealthkitPermissions() {
        let sampleTypesToRead = Set([
            HKObjectType.categoryType(forIdentifier: .headache)!,
        ])
        
        healthStore.requestAuthorization(toShare: nil, read: sampleTypesToRead) { (success, error) in
            print("Request Authorization -- Success: ", success, " Error: ", error ?? "nil")
        }
    }
    
    public func readHKSample(_ identifier: HKCategoryTypeIdentifier) {
        let sampleType  = HKObjectType.categoryType(forIdentifier: identifier)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let sampleQuery = HKSampleQuery.init(
            sampleType: sampleType,
            predicate: get24hPredicate(),
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor],
            resultsHandler: { (query, results, error) in
                guard let samples = results as? [HKCategorySample] else {
                    print(error!)
                    
                    return
                }
                
                for sample in samples {
                    // let mSample = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                    
                    print("SAMPLE: ", sample.value, " ", sample.startDate, " ", sample.endDate, " ", sample.metadata ?? "nil")
                    
                    print("ENTRY: ",
                          Entry(
                              date: sample.startDate,
                              severity: self.getSymptomSeverity(sample.value),
                              triggers: []
                          )
                    )
                }
            }
        )
        
        self.healthStore .execute(sampleQuery)
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
    
    private func get24hPredicate() ->  NSPredicate{
        let today = Date()
        let startDate = Calendar.current.date(byAdding: .hour, value: -24, to: today)
        let predicate = HKQuery.predicateForSamples(withStart: startDate,end: today,options: [])
        return predicate
    }
}
