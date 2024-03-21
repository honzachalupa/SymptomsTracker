import SwiftUI

struct SymptomsListView: View {
    @State var dataStore = DataStoreManager()
    
    var body: some View {
        List {
            /* Section("All symptoms summary") {
                SummaryChartView()
                    .padding(.bottom, 10)
                    .padding(.top, 20)
            } */
            
            ForEach(dataStore.symptoms) { symptom in
                Section {
                    NavigationLink {
                        SymptomDetailScreen(symptom: symptom)
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                SymptomNameWithIcon(name: symptom.name, icon: symptom.icon)
                                
                                Spacer()
                                
                                HealthKitConnectionLabel(symptom: symptom)
                            }
                            
                            EntriesChartView(symptomEntries: symptom.entries!)
                                .aspectRatio(3, contentMode: .fit)
                                .padding(.vertical, 20)
                        }
                    }
                }
            }
        }
        .padding(.top, 10)
        .refreshable {
            dataStore.refreshData()
        }
    }
}

#Preview {
    SymptomsListView()
        .modelContainer(previewContainer)
}
