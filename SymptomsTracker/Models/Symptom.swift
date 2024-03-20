import Foundation
import SwiftData
import HealthKit

@Model
class Symptom: Identifiable {
    var name: String = ""
    var icon: String = ""
    var origin: SymptomOrigin = SymptomOrigin.manual
    var healthKitTypeIdentifier: TypeIdentifiers? = TypeIdentifiers.headache
    var note: String? = ""
    @Relationship(deleteRule: .cascade, inverse: \Entry.symptomRel) var entries: [Entry]? = [Entry]()
    
    init(
        name: String,
        icon: String,
        origin: SymptomOrigin,
        healthKitTypeIdentifier: TypeIdentifiers? = nil,
        note: String? = nil,
        entries: [Entry]? = []
    ) {
        self.name = name
        self.icon = icon
        self.origin = origin
        self.healthKitTypeIdentifier = healthKitTypeIdentifier
        self.note = note
        self.entries = entries
    }
}

enum SymptomOrigin: CaseIterable, Codable {
    case healthKit, manual
}

var HealthKitSymptoms = [
    Symptom(
        name: "Headache",
        icon: "🤕",
        origin: .healthKit,
        healthKitTypeIdentifier: .headache
    ),
    Symptom(
        name: "Cough",
        icon: "🤧",
        origin: .healthKit,
        healthKitTypeIdentifier: .coughing
    ),
    Symptom(
        name: "Fever",
        icon: "🤒",
        origin: .healthKit,
        healthKitTypeIdentifier: .fever
    )
]

var symptomsMock = [
    Symptom(
        name: "Mocked symptom 1",
        icon: "😮‍💨",
        origin: .healthKit,
        entries: []
    ),
    Symptom(
        name: "Mocked symptom 2",
        icon: "😮‍💨",
        origin: .manual,
        note: "Mocked note note note note",
        entries: []
    ),
    Symptom(
        name: "Mocked symptom 3",
        icon: "😒",
        origin: .manual,
        note: "Mocked note note note note",
        entries: entriesMock
    ),
    Symptom(
        name: "Mocked symptom 4",
        icon: "❓",
        origin: .manual,
        note: "Mocked note note note note",
        entries: []
    )
]
