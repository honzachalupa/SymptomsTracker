import Foundation
import SwiftData
import HealthKit

@Model
class Symptom: Identifiable {
    var name: String = ""
    var icon: String = ""
    var typeIdentifier: TypeIdentifiers? = TypeIdentifiers.headache
    var note: String? = ""
    @Relationship(deleteRule: .cascade, inverse: \Entry.symptomRel) var entries: [Entry]? = [Entry]()
    
    init(
        name: String,
        icon: String,
        typeIdentifier: TypeIdentifiers? = nil,
        note: String? = nil,
        entries: [Entry]? = []
    ) {
        self.name = name
        self.icon = icon
        self.typeIdentifier = typeIdentifier
        self.note = note
        self.entries = entries
    }
}

var HealthKitSymptoms = [
    Symptom(
        name: "Headache",
        icon: "🤕",
        typeIdentifier: .headache
    ),
    Symptom(
        name: "Cough",
        icon: "🤧",
        typeIdentifier: .coughing
    ),
    Symptom(
        name: "Fever",
        icon: "🤒",
        typeIdentifier: .fever
    )
]

var symptomsMock = [
    Symptom(
        name: "Mocked symptom 1",
        icon: "😮‍💨",
        typeIdentifier: .headache,
        entries: []
    ),
    Symptom(
        name: "Mocked symptom 2",
        icon: "😮‍💨",
        note: "Mocked note note note note",
        entries: []
    ),
    Symptom(
        name: "Mocked symptom 3",
        icon: "😒",
        note: "Mocked note note note note",
        entries: entriesMock
    ),
    Symptom(
        name: "Mocked symptom 4",
        icon: "❓",
        note: "Mocked note note note note",
        entries: []
    )
]
