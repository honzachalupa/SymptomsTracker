import SwiftUI

func SymptomNameWithIcon(name: String, icon: String) -> Text {
    Text("\(icon) \(name)".trimmingCharacters(in: .whitespaces))
}
