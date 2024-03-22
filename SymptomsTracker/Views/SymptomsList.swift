import SwiftUI

struct SymptomsListView: View {
    @State var dataStore = DataStoreManager()
    
    var body: some View {
        VStack {
            if dataStore.symptoms.isEmpty {
                Spacer()
                
                Text("Add a new symptom to start tracking.")
                    .frame(maxWidth: 300)
                    .opacity(0.8)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 5)
                
                NavigationLink {
                    SymptomCreateScreen()
                } label: {
                    Label("Create symptom", systemImage: "plus")
                        
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            } else {
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
                .refreshable {
                    dataStore.refreshData()
                }
            }
        }
        .onAppear() {
            dataStore.refreshData()
        }
    }
}

#Preview {
    SymptomsListView()
        .modelContainer(previewContainer)
}
