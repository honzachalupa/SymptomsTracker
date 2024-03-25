import SwiftUI

struct Insights: View {
    @ObservedObject var insightsManager = InsightsManager()
    
    var body: some View {
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
                ForEach(insightsManager.advices, id: \.content) { advice in
                    VStack {
                        Text(advice.content)
                            .multilineTextAlignment(.center)
                        
                        Text("Relates with: " + advice.relations.joined(separator: ", "))
                    }
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

#Preview {
    Insights()
}
