import SwiftUI
import SwiftData

struct SymptonsListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Symptom.name) private var symptoms: [Symptom]
    
    var body: some View {
        List {
            ForEach(symptoms) { symptom in
                Section {
                    VStack(alignment: .leading) {
                        SymptomNameWithIcon(name: symptom.name, icon: symptom.icon)
                    
                        ChartView(symptomEntries: symptom.entries!)
                            .aspectRatio(3, contentMode: .fit)
                            .padding(.vertical, 20)
                        
                        Divider()
                        
                        NavigationLink {
                            SymptomDetailScreen(symptom: symptom)
                        } label: {
                            Text("Detail")
                                .foregroundStyle(.blue)
                                .padding(.top, 5)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SymptonsListView()
        // .modelContainer(for: [Symptom.self])
}
