import SwiftUI
import SwiftData

struct SymptomsListView: View {
    @Query(sort: \Symptom.name) private var symptoms: [Symptom]
    
    var body: some View {
        List {
            /* Section("All symptoms summary") {
                SummaryChartView()
                    .padding(.bottom, 10)
                    .padding(.top, 20)
            } */
            
            ForEach(symptoms) { symptom in
                Section {
                    VStack(alignment: .leading) {
                        HStack {
                            SymptomNameWithIcon(name: symptom.name, icon: symptom.icon)
                            
                            Spacer()
                            
                            HealthKitConnectionLabel(symptom: symptom)
                        }
                    
                        EntriesChartView(symptomEntries: symptom.entries!)
                            .aspectRatio(3, contentMode: .fit)
                            .padding(.vertical, 20)
                        
                        Divider()
                        
                        NavigationLink {
                            SymptomDetailScreen(symptom: symptom)
                        } label: {
                            HStack {
                                Spacer()
                                
                                Text("Detail")
                            }
                            .foregroundStyle(.blue)
                        }
                        .padding(.top, 3)
                    }
                }
            }
        }
        .padding(.top, 10)
    }
}

#Preview {
    SymptomsListView()
        .modelContainer(previewContainer)
}
