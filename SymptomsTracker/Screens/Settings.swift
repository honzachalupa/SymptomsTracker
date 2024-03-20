import SwiftUI

struct SettingsScreen: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var isDeleteConfirmationShown: Bool = false
    
    private func flushData() {
        do {
            try modelContext.delete(model: Symptom.self)
            try modelContext.delete(model: Entry.self)
            try modelContext.delete(model: Trigger.self)
        } catch {
            print("Failed to clear all Country and City data.")
        }
    }
    
    var body: some View {
        List {
            Button(role: .destructive, action: { isDeleteConfirmationShown.toggle() }, label: {
                Text("Delete all data")
            })
            .confirmationDialog(
                "Are you sure?",
                isPresented: $isDeleteConfirmationShown,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    withAnimation {
                        flushData()
                    }
                }
                .keyboardShortcut(.defaultAction)
                
                Button("No", role: .cancel) {}
            }
        }
    }
}

#Preview {
    SettingsScreen()
        .modelContainer(previewContainer)
}
