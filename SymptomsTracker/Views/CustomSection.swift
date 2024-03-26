import SwiftUI

struct CustomSection<Content: View>: View {
    var title: String? = nil
    var content: Content
    
    init(_ title: String? = nil, content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack {
            if let title = title {
                HStack {
                    Text(title)
                        .font(.footnote)
                        .opacity(0.55)
                        .textCase(.uppercase)
                        .padding(.leading, 23)
                    
                    Spacer()
                }
            }
            
            VStack(alignment: .leading) {
                HStack {
                    content
                    
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.regularMaterial)
            .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    VStack {
        CustomSection {
            Text("Content without title")
        }
        
        Divider()
        
        CustomSection("Title") {
            Text("Content with title")
        }
    }
}
