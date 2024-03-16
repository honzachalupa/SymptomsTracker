import Foundation
import SwiftData

@Model
class Symptom: Identifiable {
    var name: String = ""
    var icon: String = ""
    var note: String? = ""
    @Relationship(deleteRule: .cascade, inverse: \Entry.symptomRel) var entries: [Entry]? = [Entry]()
    
    init(name: String, icon: String, note: String, entries: [Entry]? = []) {
        self.name = name
        self.icon = icon
        self.note = note
        self.entries = entries
    }
}

var symptomsMock = [
    Symptom(
        name: "Mocked symptom 1",
        icon: "😮‍💨",
        note: "Mocked note note note note",
        entries: []
    ),
    Symptom(
        name: "Mocked symptom 2",
        icon: "😒",
        note: "Mocked note note note note",
        entries: entriesMock
    ),
    Symptom(
        name: "Mocked symptom 3",
        icon: "❓",
        note: "Mocked note note note note",
        entries: []
    )
]
