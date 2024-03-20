import SwiftUI
import Charts

struct EntreiesChartRecord: Identifiable {
    var id: UUID
    var date: Date
    var severityInt: Int
    
    init(date: Date, severity: Severity) {
        self.id = UUID()
        self.date = date
        self.severityInt = severity == .mild ? 0 : severity == .moderate ? 1 : 2
    }
}

struct EntriesChartView: View {
    var symptomEntries: [Entry]
    
    @State var data: [EntreiesChartRecord] = []
    
    private func calculateDateDomain() -> ClosedRange<Date> {
        let sortedDates = symptomEntries.map { Locale.current.calendar.startOfDay(for: $0.date) }.sorted()
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: sortedDates.first ?? Date())!
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: sortedDates.last ?? Date())!
        
        return startDate...endDate
    }
    
    private func proccessData() {
        data = symptomEntries
            .sorted(by: {
                $0.date < $1.date
            })
            .map { entry in
                EntreiesChartRecord(
                    date: Locale.current.calendar.startOfDay(for: entry.date),
                    severity: entry.severity
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
                Chart(data, id: \.id) { record in
                    LineMark(
                        x: .value("Date", record.date),
                        y: .value("Severity", record.severityInt)
                        // width: 15,
                        // stacking: .unstacked
                    )
                    // .interpolationMethod(.cardinal)
                    // .foregroundStyle(getSeverityColor(record.severityInt))
                    .foregroundStyle(
                        .linearGradient(
                            colors: [.yellow, .orange, .red],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    // .cornerRadius(5)
                    
                    PointMark(
                        x: .value("Date", record.date),
                        y: .value("Severity", record.severityInt)
                        // width: 15,
                        // stacking: .unstacked
                    )
                    .foregroundStyle(getSeverityColor(record.severityInt))
                }
                .chartYAxis {
                    AxisMarks {
                        let value = $0.as(Int.self)!
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            Text(getSeverityLabelFromInt(value))
                        }
                    }
                }
                .chartXScale(domain: calculateDateDomain())
                // .chartScrollableAxes(.horizontal)
            }
        }
        .onAppear {
            proccessData()
        }
        .onChange(of: symptomEntries) {
            proccessData()
        }
    }
}

#Preview {
    EntriesChartView(symptomEntries: entriesMock)
}
