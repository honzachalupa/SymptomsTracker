import SwiftUI
import Charts

struct ChartRecord: Identifiable {
    var id: UUID
    var date: Date
    var severityInt: Int
    
    init(date: Date, severity: Severity) {
        self.id = UUID()
        self.date = date
        self.severityInt = severity == .mild ? 1 : severity == .moderate ? 2 : 3
    }
}

struct ChartView: View {
    var symptomEntries: [Entry]
    
    @State var data: [ChartRecord] = []
    
    private func calculateDateDomain() -> ClosedRange<Date> {
        let sortedDates = symptomEntries.map { $0.date }.sorted()
        let startDate = sortedDates.first ?? Calendar.current.date(byAdding: .day, value: -5, to: Date())!
        let endDate = sortedDates.last ?? Date()
        
        return startDate...endDate
    }
    
    private func proccessData() {
        data = symptomEntries.map { entry in
            ChartRecord(
                date: entry.date,
                severity: entry.severity
            )
        }.sorted(by: {
            $0.date < $1.date
        })
    }
    
    var body: some View {
        if symptomEntries.count > 1 {
            Chart(data, id: \.id) { record in
                BarMark(
                    x: .value("Date", record.date),
                    y: .value("Severity", record.severityInt)
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )
            }
            .chartXScale(domain: calculateDateDomain())
            // .chartScrollableAxes(.horizontal)
            .onAppear {
                proccessData()
            }
            .onChange(of: symptomEntries) {
                proccessData()
            }
        }
    }
}

#Preview {
    ChartView(symptomEntries: entriesMock)
}
