import SwiftUI

struct SymptomsListSectionView: View {
    @EnvironmentObject var dataStore: DataStoreManager
    @Binding var selectedSymptom: Symptom?
    
    func delete(_ symptom: Symptom) {
        Task {
            await dataStore.delete(symptom)
        }
    }
    
    var body: some View {
        Section {
            ForEach(dataStore.symptoms, id: \.id) { symptom in
                NavigationLink {
                    SymptomDetailScreen(symptom: symptom)
                } label: {
                    Group {
                        if UIDevice.isIPad {
                            SymptomNameWithIcon(symptom.name, symptom.icon, spacing: 3)
                        } else {
                            SymptomNameWithIcon(symptom.name, symptom.icon, spacing: 8)
                        }
                        
                        Spacer()
                        
                        UnitCount(.entry, symptom.entries!.count)
                            .opacity(0.5)
                    }
                    .padding(.leading, 3)
                }
                .swipeActions {
                    Button("Delete", role: .destructive) {
                        delete(symptom)
                    }
                }
            }
            
            NavigationLink {
                SymptomCreateScreen()
            } label: {
                Label("Create symptom", systemImage: "plus")
            }
        }
        .onAppear() {
            if let symptom = dataStore.symptoms.first {
                selectedSymptom = symptom
            }
        }
    }
}

/* #Preview {
    SymptomsListSectionView()
        // .modelContainer(previewContainer)
} */
