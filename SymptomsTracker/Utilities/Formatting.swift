import SwiftUI

let severityLabel_mild = String(localized: "Mild")
let severityLabel_moderate = String(localized: "Moderate")
let severityLabel_severe = String(localized: "Severe")

func getSeverityLabel(_ severity: Severity) -> String {
    switch severity {
        case .mild:
            return severityLabel_mild
        case .moderate:
            return severityLabel_moderate
        case .severe:
            return severityLabel_severe
    }
}

func getSeverityLabelFromInt(_ severity: Int) -> String {
    switch severity {
        case 0:
            return severityLabel_mild
        case 1:
            return severityLabel_moderate
        default:
            return severityLabel_severe
    }
}

func getSeverityColor(_ severity: Severity) -> Color {
    switch severity {
        case .mild:
            return .yellow
        case .moderate:
            return .orange
        case .severe:
            return .red
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    
    return formatter
}()
