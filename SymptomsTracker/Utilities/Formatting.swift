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


func formatDate(_ date: Date, showTime: Bool = false) -> String {
    let calendar = Calendar.current
    let now = Date.now
    let startOfToday = calendar.startOfDay(for: now)
    let startOfDayOnDate = calendar.startOfDay(for: date)
    let formatter = DateFormatter()
    
    let daysFromToday = calendar.dateComponents([.day], from: startOfToday, to: startOfDayOnDate).day!
    
    if abs(daysFromToday) <= 1 {
        // Yesterday, today or tomorrow
        formatter.dateStyle = .full
        formatter.doesRelativeDateFormatting = true
        
        if showTime {
            formatter.timeStyle = .short
        }
    }
    else if calendar.component(.year, from: date) == calendar.component(.year, from: now) {
        // Another date this year
        if showTime {
            formatter.setLocalizedDateFormatFromTemplate("dM H:mm")
        } else {
            formatter.setLocalizedDateFormatFromTemplate("dM")
        }
    }
    else {
        // Another date in another year
        if showTime {
            formatter.setLocalizedDateFormatFromTemplate("dMyyyy H:mm")
        } else {
            formatter.setLocalizedDateFormatFromTemplate("dMyyyy")
        }
    }
    
    let formatted = formatter.string(from: date).localizedCapitalized
    let firstLetter = formatted.prefix(1).capitalized
    let remainingLetters = formatted.dropFirst().lowercased()
    
    return firstLetter + remainingLetters
}
