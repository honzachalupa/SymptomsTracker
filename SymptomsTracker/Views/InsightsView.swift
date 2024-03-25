import SwiftUI

struct Insights: View {
    @ObservedObject var insightsManager = InsightsManager()
    
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
                    ForEach(insightsManager.advices, id: \.content) { advice in
                        VStack {
                            Text(advice.content)
                                .multilineTextAlignment(.center)
                            
                            Text("Relates with: " + advice.relations.joined(separator: ", "))
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
    Insights()
}
