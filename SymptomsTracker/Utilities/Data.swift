func groupByHealthKitTypeCategory(_ data: [HealthKitType]) -> [String: [HealthKitType]] {
    return Dictionary(grouping: data, by: { "\($0.category)" })
}

extension Array where Element: Hashable {
  func unique() -> [Element] {
    Array(Set(self))
  }
}
