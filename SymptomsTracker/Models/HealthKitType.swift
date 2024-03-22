import HealthKit
import SwiftData

enum TypeIdentifier: Codable {
    case headache, coughing, fever, appetiteChanges, bloating, breastPain, chills, constipation, diarrhea
}

let typeIdentifierMapping: [TypeIdentifier: HKCategoryTypeIdentifier] = [
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

enum HealthKitTypeCategory: Codable {
    case abdominalAndGastrointestinal, constitutional, heartAndLung, neurological
}

@Model
final class HealthKitType: Identifiable {
    var id = UUID()
    var key: TypeIdentifier = TypeIdentifier.headache
    var name: String = ""
    var icon: String = ""
    var note: String? = nil
    var category: HealthKitTypeCategory = HealthKitTypeCategory.neurological
    var symptomRel: Symptom?
    
    init(
        key: TypeIdentifier,
        name: String,
        icon: String,
        note: String? = nil,
        category: HealthKitTypeCategory
    ) {
        self.key = key
        self.name = name
        self.icon = icon
        self.note = note
        self.category = category
    }
}

let HealthKitTypes = [
    HealthKitType(
        key: .headache,
        name: String(localized: "Headache"),
        icon: "🤯",
        category: .neurological
    ),
    HealthKitType(
        key: .coughing,
        name: String(localized: "Coughing"),
        icon: "😷",
        category: .heartAndLung
    ),
    HealthKitType(
        key: .fever,
        name: String(localized: "Fever"),
        icon: "🤒",
        category: .constitutional
    )
]
