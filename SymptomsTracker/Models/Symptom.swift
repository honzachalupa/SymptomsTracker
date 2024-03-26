import Foundation
import SwiftData
import HealthKit

@Model
final class Symptom: Identifiable {
    // var id = UUID()
    var name: String = ""
    var icon: String = ""
    var note: String? = ""
    
    @Relationship(deleteRule: .nullify, inverse: \HealthKitType.symptomRel)
    var healthKitType: HealthKitType? = nil
    
    @Relationship(deleteRule: .cascade, inverse: \Entry.symptomRel)
    var entries: [Entry]? = [Entry]()
    
    init(
        name: String,
        icon: String,
        note: String? = nil,
        healthKitType: HealthKitType? = nil,
        entries: [Entry]? = []
    ) {
        self.name = name
        self.icon = icon
        self.note = note
        self.healthKitType = healthKitType
        self.entries = entries
    }
}

var symptomsMock = [
    Symptom(
        name: "Mocked symptom 1",
        icon: "😮‍💨",
        healthKitType: HealthKitTypes[0],
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
