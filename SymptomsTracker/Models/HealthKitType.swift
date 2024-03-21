import HealthKit
import SwiftData

enum TypeIdentifiers: Codable {
    case headache, coughing, fever, appetiteChanges, bloating, breastPain, chills, constipation, diarrhea
}

let typeIdentifierMapping: [TypeIdentifiers: HKCategoryTypeIdentifier] = [
    .headache: .headache,
    .coughing: .coughing,
    .fever: .fever,
    .appetiteChanges: .appetiteChanges,
    .bloating: .bloating,
    .breastPain: .breastPain,
    .chills: .chills,
    .constipation: .constipation,
    .diarrhea: .diarrhea
]

@Model
final class HealthKitType: Identifiable {
    var id = UUID()
    var key: TypeIdentifiers = TypeIdentifiers.headache
    var name: String = ""
    var icon: String = ""
    var note: String? = nil
    var symptomRel: Symptom?
    
    init(
        key: TypeIdentifiers,
        name: String,
        icon: String,
        note: String? = nil
    ) {
        self.key = key
        self.name = name
        self.icon = icon
        self.note = note
    }
}

let HealthKitTypes = [
    HealthKitType(
        key: .headache,
        name: String(localized: "Headache"),
        icon: "🤯"
    ),
    HealthKitType(
        key: .coughing,
        name: String(localized: "Coughing"),
        icon: "😷"
    ),
    HealthKitType(
        key: .fever,
        name: String(localized: "Fever"),
        icon: "🤒"
    )
]
