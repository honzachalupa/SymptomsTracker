import SwiftUI

enum UnitCountType {
    case symptom, trigger, entry
}

struct UnitCount: View {
    var type: UnitCountType
    var count: Int
    
    let locale = Locale.preferredLanguages[0]
    
    init(_ type: UnitCountType, _ count: Int) {
        self.type = type
        self.count = count
    }
    
    func formatCountCS() -> String {
        if type == .symptom {
            if count == 0 || count >= 5 {
                return "\(count) symptomů"
            } else if count == 1 {
                return "\(count) symptom"
            } else if count >= 2 && count <= 4 {
               return "\(count) symptomy"
           }
        } else if type == .trigger {
            if count == 0 || count >= 5 {
                return "\(count) spouštěčů"
            } else if count == 1 {
                return "\(count) spouštěč"
            } else if count >= 2 && count <= 4 {
               return "\(count) spouštěče"
           }
        } else {
            if count == 0 || count >= 5 {
                return "\(count) záznamů"
            } else if count == 1 {
                return "\(count) záznam"
            } else if count >= 2 && count <= 4 {
               return "\(count) záznamy"
           }
        }
        
        print("Error in formatCountCS function.")
        
        return "\(count) \(type)";
    }
    
    var body: some View {
        if locale.contains("cs") {
            Text(formatCountCS())
        } else if type == .symptom {
            Text("^[\(count) symptom](inflect: true)")
        } else if type == .trigger {
           Text("^[\(count) trigger](inflect: true)")
        } else if type == .entry {
           Text("^[\(count) entry](inflect: true)")
        }
    }
}

#Preview {
    UnitCount(.entry, 10)
}
