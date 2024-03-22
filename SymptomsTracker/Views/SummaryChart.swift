import SwiftUI
import SwiftData
import Charts

struct SummaryChartRecord: Identifiable {
    var id: UUID
    var date: Date
    var severityInt: Int
    
    init(date: Date, severity: Severity) {
        self.id = UUID()
        self.date = date
        self.severityInt = severity == .mild ? 0 : severity == .moderate ? 1 : 2
    }
}

struct SummaryChartRecords: Identifiable {
    var id: UUID
    var symptom: Symptom
    var entries: [SummaryChartRecord]
    
    init(symptom: Symptom, entries: [SummaryChartRecord]) {
        self.id = UUID()
        self.symptom = symptom
        self.entries = entries
    }
}

struct SummaryChartView: View {
    @State private var dataStore = DataStoreManager()
    @State var data: [SummaryChartRecords] = []
    
    private func calculateDateDomain() -> ClosedRange<Date> {
        let sortedDates = dataStore.symptoms.flatMap { $0.entries ?? [] }.map { Locale.current.calendar.startOfDay(for: $0.date) }.sorted()
        let startDate = min(
            Calendar.current.date(byAdding: .day, value: -1, to: sortedDates.first ?? Date())!,
            Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        )
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: sortedDates.last ?? Date())!
        
        return startDate...endDate
    }
    
    private func proccessData() {
        data = dataStore.symptoms
            .map { symptom in
                SummaryChartRecords(
                    symptom: symptom,
                    entries: symptom.entries?
                        .sorted(by: {
                            $0.date < $1.date
                        })
                        .map { entry in
                            SummaryChartRecord(
                                date: Locale.current.calendar.startOfDay(for: entry.date),
                                severity: entry.severity
                            )
                        } ?? []
                )
            }
    }
    
    private func getSeverityColor(_ severityInt: Int) -> Color {
        switch severityInt {
            case 0:
                return .yellow
            case 1:
                return .orange
            default:
                return .red
        }
    }
    
    var body: some View {
        ZStack {
            if data.count > 1 {
                Chart(data, id: \.symptom.name) { recordSet in
                    ForEach(recordSet.entries) { record in
                        LineMark(
                            x: .value("Date", record.date),
                            y: .value("Severity", record.severityInt)
                        )
                        .foregroundStyle(getSeverityColor(record.severityInt))
                    }
                }
                .chartXScale(domain: calculateDateDomain())
                .frame(height: 300)
            }
        }
        .onAppear {
            proccessData()
        }
        .onChange(of: dataStore.symptoms) {
            proccessData()
        }
    }
}

#Preview {
    SummaryChartView()
        // .modelContainer(previewContainer)
}
