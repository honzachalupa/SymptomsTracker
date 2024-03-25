import Foundation
import ChatGPTSwift

struct ChatGPTResponseItem: Codable {
    var content: String
    var relations: [String]
}

class InsightsManager: ObservableObject {
    private let api = ChatGPTAPI(apiKey: "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")
    private var dataStore = DataStoreManager()
    private var lastTimeRefreshed: Date = Date()
    
    @Published var advices: [ChatGPTResponseItem] = []
    @Published var isLoading: Bool = false
    
    init() {
        // let oneHourElapsed = Calendar.current.date(byAdding: .hour, value: 1, to: lastTimeRefreshed)! < Date()
        
        // if oneHourElapsed {
            self.refreshInsights()
        // }
    }
    
    public func refreshInsights() {
        isLoading = true
        lastTimeRefreshed = Date()
        
        let message = getMessage(dataStore.symptoms, dataStore.triggers)
        
        consoleLog("CHAT_GPT message", message)
        
        Task {
            do {
                let response = try await api.sendMessage(text: message)
                
                consoleLog("CHAT_GPT response", response)
                
                let decoder = JSONDecoder()
                let parsedResponse = try decoder.decode([ChatGPTResponseItem].self, from: response.data(using: .utf8)!)
                
                consoleLog("CHAT_GPT parsedResponse", parsedResponse)
                
                parsedResponse.forEach { advice in
                    advices.append(advice)
                }
                
                isLoading = false
            } catch {
                consoleLog("CHAT_GPT error", "\(error)")
                
                isLoading = false
            }
        }
    }
    
    private func getMessage(_ symptoms: [Symptom], _ triggers: [Trigger]) -> String {
        return """
Input data: Symptoms: \(symptoms.map { $0.name }.joined(separator: ", "))
Triggers: \(triggers.map { $0.name }.joined(separator: ", "))
Response locale: \(Locale.preferredLanguages[0])

I am suffering from health symptoms and they may be causing them.
Give me three practical recommendations that could help me (advice).
For each recommendation, specify which symptom or trigger it relates to (relatedSymptom).

Response format is JSON: [{ "content": "{{advice}}", "relations": [{{related symptom or trigger}}] }]
Output raw JSON and nothing else. Do not add any marks (like `json * `). [no prose]
"""
    }
}
