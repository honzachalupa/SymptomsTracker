import Foundation
import ChatGPTSwift

struct ChatGPTResponseItem: Codable {
    var content: String
    var relations: [String]
}

class InsightsManager: ObservableObject {
    private let api = ChatGPTAPI(apiKey: "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")
    private var dataStore = DataStoreManager()
    
    @Published var advices: [ChatGPTResponseItem] = []
    @Published var isLoading: Bool = false
    
    init() {
        let oneHourElapsed = true // Calendar.current.date(byAdding: .hour, value: 1, to: lastTimeRefreshed)! > Date()
        
        if oneHourElapsed {
            Task {
                await self.refreshInsights()
            }
        }
    }
    
    public func refreshInsights() async {
        isLoading = true
        
        let message = getMessage()
        
        consoleLog("INSIGHTS message", message)
        
        do {
            let response = try await api.sendMessage(text: message)
            
            consoleLog("INSIGHTS response", response)
            
            let decoder = JSONDecoder()
            let parsedResponse = try decoder.decode([ChatGPTResponseItem].self, from: response.data(using: .utf8)!)
            
            parsedResponse.forEach { advice in
                advices.append(advice)
            }
            
            consoleLog("INSIGHTS cache set", parsedResponse)
            
            isLoading = false
        } catch {
            consoleLog("INSIGHTS error", "\(error)")
            
            isLoading = false
        }
    }
    
    private func getMessage() -> String {
        return """
Input data: Symptoms: \(dataStore.symptoms.map { $0.name }.joined(separator: ", "))
Triggers: \(dataStore.triggers.map { $0.name }.joined(separator: ", "))
Response locale: \(Locale.preferredLanguages[0])

I am suffering from health symptoms and they may be causing them.
Give me three practical recommendations that could help me (advice).
For each recommendation, specify which symptom or trigger it relates to (relatedSymptom).

Response format is JSON: [{ "content": "{{advice}}", "relations": [{{related symptom or trigger}}] }]
Output raw JSON and nothing else. Do not add any marks (like `json * `). [no prose]
"""
    }
}
