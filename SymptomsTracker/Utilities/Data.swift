func groupByHealthKitTypeCategory(_ data: [HealthKitType]) -> [String: [HealthKitType]] {
    return Dictionary(grouping: data, by: { "\($0.category)" })
}
