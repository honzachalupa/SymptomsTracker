import SwiftUI

func SymptomNameWithIconText(_ name: String, _ icon: String) -> Text {
    Text("\(icon) \(name)".trimmingCharacters(in: .whitespaces))
}

struct SymptomNameWithIcon: View {
    var name: String
    var icon: String
    var spacing: CGFloat = 0
    
    init(_ name: String, _ icon: String, spacing: CGFloat = 0) {
        self.name = name
        self.icon = icon
        self.spacing = spacing
    }
    
    var body: some View {
        HStack {
            Text(icon)
                .padding(.trailing, spacing)
            
            Text(name)
        }
    }
}

#Preview {
    VStack {
        SymptomNameWithIconText("Name", "🙂")
        SymptomNameWithIcon("Name", "🙂")
        SymptomNameWithIcon("Name", "🙂", spacing: 20)
    }
}
