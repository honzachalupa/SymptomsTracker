import Foundation
import SwiftData

@Model
final class Insight: Identifiable {
    var id = UUID()
    var content: String
    var relations: [String]
    
    init(content: String, relations: [String]) {
        self.content = content
        self.relations = relations
    }
}
