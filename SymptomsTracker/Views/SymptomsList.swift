import SwiftUI

struct SymptomsListView: View {
    @EnvironmentObject var dataStore: DataStoreManager
    
    var body: some View {
        VStack {
            if dataStore.isLoading {
                ProgressView {
                    Text("Loading...")
                }
            } else if dataStore.symptoms.isEmpty {
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
                    
                    Section("AI insights") {
                        Insights()
                    }
                    
                    ForEach(dataStore.symptoms, id: \.id) { symptom in
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
                                    
                                    if let entries = symptom.entries {
                                        EntriesChartView(symptomEntries: entries)
                                    }
                                }
                            }
                        }
                    }
                }
                .refreshable {
                    Task {
                        await dataStore.refreshData()
                    }
                }
            }
        }
        .task {
            await dataStore.refreshData()
        }
        .onChange(of: dataStore.symptoms) { _, newValue in
            consoleLog("DATASTORE onChange", newValue);
            consoleLog("DATASTORE onChange isEmpty", dataStore.symptoms.isEmpty);
        }
    }
}

#Preview {
    SymptomsListView()
        // .modelContainer(previewContainer)
}
