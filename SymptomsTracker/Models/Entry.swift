import Foundation
import SwiftData

@Model
class Entry: Identifiable {
    var id = UUID()
    var date: Date = Date()
    var severity: Severity = Severity.moderate
    var symptomRel: Symptom?
    @Relationship(deleteRule: .nullify, inverse: \Trigger.entriesRel) var triggers: [Trigger]? = [Trigger]()
    
    init(id: UUID? = nil, date: Date, severity: Severity, triggers: [Trigger]) {
        if let _id = id {
            self.id = _id
        }
        self.date = date
        self.severity = severity
        self.triggers = triggers
    }
}

enum Severity: CaseIterable, Codable {
    case mild
    case moderate
    case severe
}

var entriesMock = [
    Entry(
        date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
        severity: .mild,
        triggers: triggersMock
    ),
    Entry(
        date: Calendar.current.date(byAdding: .day, value: 4, to: Date())!,
        severity: .moderate,
        triggers: []
    ),
    Entry(
        date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
        severity: .mild,
        triggers: triggersMock
    ),
    Entry(
        date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
        severity: .severe,
        triggers: triggersMock
    ),
    Entry(
        date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
        severity: .moderate,
        triggers: []
    ),
    Entry(
        date: Date(),
        severity: .severe,
        triggers: []
    )
]
