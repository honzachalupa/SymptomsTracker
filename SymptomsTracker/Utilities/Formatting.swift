import Foundation

func getSeverityLabel(_ severity: Severity) -> String {
    switch severity {
        case .mild:
            return String(localized: "Mild")
        case .moderate:
            return String(localized: "Moderate")
        case .severe:
            return String(localized: "Severe")
    }
}

func getOriginLabel(_ origin: SymptomOrigin) -> String {
    switch origin {
        case .manual:
            return String(localized: "Create manualy")
        case .healthKit:
            return String(localized: "Add from Health app")
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    
    return formatter
}()
