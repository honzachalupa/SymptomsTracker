import SwiftUI

struct InsightsView: View {
    var insightsManager = InsightsManager()
    
    @EnvironmentObject var dataStore: DataStoreManager
    
    func formatRelations(_ relations: [String]) -> String {
        return relations.joined(separator: ", ")
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            if insightsManager.isLoading {
                HStack {
                    Spacer()
                    
                    ProgressView {
                        Text("Creating AI insights...")
                    }
                    
                    Spacer()
                }
            } else {
                TabView {
                    ForEach(dataStore.insights, id: \.content) { advice in
                        VStack {
                            Text(advice.content)
                                .multilineTextAlignment(.center)
                            
                            Text("Relates to: \(formatRelations(advice.relations))")
                                .opacity(0.5)
                                .font(.footnote)
                                .padding(.top, 3)
                        }
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            
            Spacer()
        }
        .frame(minHeight: 140)
    }
}

#Preview {
    InsightsView()
}
