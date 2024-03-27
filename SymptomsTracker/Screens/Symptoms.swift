import SwiftUI

struct SymptomsScreen: View {
    @EnvironmentObject var dataStore: DataStoreManager
    @Binding var selectedSymptom: Symptom?
    
    var body: some View {
        ScrollView {
            CustomSection("All symptoms summary") {
                SummaryChartView()
                    .padding(.bottom, 10)
                    .padding(.top, 20)
                    .frame(maxHeight: 300)
             }
            
            CustomSection("AI insights") {
                // InsightsView()
                Text("TODO")
            }
            
            SymptomsListSectionView(selectedSymptom: $selectedSymptom)
        }
        .refreshable {
            Task {
                await dataStore.refreshData()
            }
        }
    }
}

/* #Preview {
    SymptomsScreen(selectedSymptom: symptomsMock.first!)
} */
