import Foundation
import SwiftData

@Model
final class Trigger: Identifiable {
    var id = UUID()
    var name: String = ""
    var icon: String = ""
    var entriesRel: [Entry]? = []
    
    init(
        name: String,
        icon: String
    ) {
        self.name = name
        self.icon = icon
    }
}

var triggersMock = [
    Trigger(
        name: "Alcohol",
        icon: "🍾"
    ),
    Trigger(
        name: "Loud environment",
        icon: "🔊"
    ),
    Trigger(
        name: "Sport",
        icon: "👟"
    ),
]
