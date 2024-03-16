import Foundation
import SwiftData

@Model
class Symptom: Identifiable {
    var name: String = ""
    var icon: String = ""
    var note: String? = ""
    @Relationship(deleteRule: .cascade, inverse: \Entry.symptomRel) var entries: [Entry]? = [Entry]()
    
    init(name: String, icon: String, note: String) {
        self.name = name
        self.icon = icon
        self.note = note
    }
}

var symptomMock = Symptom(
    name: "Mocked symptom",
    icon: "❓",
    note: "Mocked note note note note"
)
